# btrfs maintenance for hosts on the shared subvolume layout (modules/nixos/disko.nix).
{config, ...}: let
  userName = config.flake.user.name;
in {
  flake.modules.nixos.btrfs = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.custom.btrfs;

    # Retention presets (snapper TIMELINE_LIMIT_*).
    presets = {
      frequent = {
        HOURLY = 24;
        DAILY = 14;
        WEEKLY = 4;
        MONTHLY = 2;
      };
      daily = {
        HOURLY = 0;
        DAILY = 7;
        WEEKLY = 4;
        MONTHLY = 3;
      };
      weekly = {
        HOURLY = 0;
        DAILY = 0;
        WEEKLY = 4;
        MONTHLY = 2;
      };
    };

    toSnapper = _: s: let
      p = presets.${s.preset};
    in
      {
        SUBVOLUME = s.path;
        FSTYPE = "btrfs";
        ALLOW_USERS = s.allowUsers;
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_MIN_AGE = 1800;
        TIMELINE_LIMIT_HOURLY = p.HOURLY;
        TIMELINE_LIMIT_DAILY = p.DAILY;
        TIMELINE_LIMIT_WEEKLY = p.WEEKLY;
        TIMELINE_LIMIT_MONTHLY = p.MONTHLY;
        TIMELINE_LIMIT_QUARTERLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      }
      // s.extraConfig;
  in {
    options.custom.btrfs.snapshots = lib.mkOption {
      description = "Snapper timeline configs, keyed by snapper config name.";
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          path = lib.mkOption {
            type = lib.types.str;
            description = "Mount point of the subvolume to snapshot.";
          };
          preset = lib.mkOption {
            type = lib.types.enum (lib.attrNames presets);
            default = "daily";
          };
          allowUsers = lib.mkOption {
            type = with lib.types; listOf str;
            default = [];
            description = "Users allowed to list/restore snapshots without sudo.";
          };
          extraConfig = lib.mkOption {
            type = with lib.types; attrsOf anything;
            default = {};
            description = "Raw snapper settings, overriding the preset.";
          };
        };
      });
      default = {};
    };

    config = {
      custom.btrfs.snapshots = {
        home = {
          path = "/home";
          preset = lib.mkDefault "frequent";
          allowUsers = lib.mkDefault [userName];
        };
        root = {
          path = "/";
          preset = lib.mkDefault "daily";
        };
      };

      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
      };

      services.snapper = {
        persistentTimer = true; # catch up on missed timeline/cleanup runs (laptops)
        configs = lib.mapAttrs toSnapper cfg.snapshots;
      };

      systemd.tmpfiles.rules =
        lib.mapAttrsToList (_: s: "v ${lib.removeSuffix "/" s.path}/.snapshots 0750 root root -") cfg.snapshots;

      #NOTE: btrfs-progs and snapper are already pulled in by the btrfs/snapper modules.
      environment.systemPackages = with pkgs; [
        compsize
        btdu
        btrfs-list
        httm
      ];
    };
  };
}
