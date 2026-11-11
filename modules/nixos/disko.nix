# Declarative disk layouts (disko). A host opts in by adding one of these
# modules in flake/hosts-nixos.nix and setting `custom.disko.*` in its
# hardware.nix. disko then GENERATES the host's `fileSystems`, so
# hardware.nix must not also declare them.
#
# disko only touches disks when you run the `disko` CLI (e.g. via
# `install-host` on the ISO). On a running system the layout is just the
# source of fileSystems, so an existing install can adopt a layout without
# reformatting as long as labels/subvolumes match what's on disk.
#
#   disko-btrfs : whole-disk GPT -> ESP (label ESP, fs label BOOT) + btrfs
#                 (label nixos). DESTRUCTIVE when run: wipes the disk.
#   disko-asahi : Apple Silicon. Never repartitions (macOS and the Asahi stub
#                 share the disk). The root partition is made by hand in free
#                 space; disko formats it only if empty and mounts the existing
#                 Asahi ESP at /boot/efi (never formats it). /boot lives on
#                 btrfs so its size isn't capped by the small Asahi ESP.
{inputs, ...}: let
  btrfsOpts = ["compress=zstd" "noatime"];

  # Same base subvolume scheme everywhere; hosts append their own via
  # `custom.disko.extraSubvolumes`. Snapper's .snapshots subvolumes are
  # created by modules/nixos/btrfs.nix, not here.
  subvolumes = cfg:
    {
      "@" = {
        mountpoint = "/";
        mountOptions = btrfsOpts;
      };
      "@home" = {
        mountpoint = "/home";
        mountOptions = btrfsOpts;
      };
      "@nix" = {
        mountpoint = "/nix";
        mountOptions = btrfsOpts;
      };
      "@log" = {
        mountpoint = "/var/log";
        mountOptions = btrfsOpts;
      };
    }
    // cfg.extraSubvolumes;

  # Device options accept either an absolute path or a bare name as printed
  # by `ls /dev/disk/by-id/` (expanded to /dev/disk/by-id/<name>).
  toDevicePath = lib: d:
    if lib.hasPrefix "/" d
    then d
    else "/dev/disk/by-id/${d}";

  devicePath = lib: description: example:
    lib.mkOption {
      type = lib.types.str;
      apply = toDevicePath lib;
      inherit description example;
    };

  commonOptions = lib: {
    extraSubvolumes = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = {};
      example = {
        "@media" = {
          mountpoint = "/srv/media";
          mountOptions = ["compress=zstd" "noatime"];
        };
      };
      description = ''
        Extra subvolumes on the root btrfs filesystem (disko subvolume syntax).
        Data on *other* disks (e.g. a RAID array) belongs in its own
        `disko.devices.disk.*` entries in the host config instead.
      '';
    };
  };
in {
  flake.modules.nixos.disko-btrfs = {
    config,
    lib,
    ...
  }: let
    cfg = config.custom.disko;
  in {
    imports = [inputs.disko.nixosModules.disko];

    options.custom.disko =
      commonOptions lib
      // {
        device =
          devicePath lib
          "Whole disk to partition: a /dev/disk/by-id path or bare by-id name."
          "nvme-Samsung_SSD_970_EVO_Plus_1TB_XXXX";
        espSize = lib.mkOption {
          type = lib.types.str;
          default = "5G";
          description = "ESP size. systemd-boot keeps every kernel/initrd here.";
        };
      };

    config = {
      disko.devices.disk.main = {
        type = "disk";
        inherit (cfg) device;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "ESP"; # partlabel; fileSystems use /dev/disk/by-partlabel/ESP
              size = cfg.espSize;
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = ["-F" "32" "-n" "BOOT"];
                mountpoint = "/boot";
                mountOptions = ["fmask=0077" "dmask=0077"];
              };
            };
            nixos = {
              label = "nixos";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f" "-L" "nixos"];
                subvolumes = subvolumes cfg;
              };
            };
          };
        };
      };
    };
  };

  flake.modules.nixos.disko-asahi = {
    config,
    lib,
    ...
  }: let
    cfg = config.custom.disko;
  in {
    imports = [inputs.disko.nixosModules.disko];

    options.custom.disko =
      commonOptions lib
      // {
        device = lib.mkOption {
          type = lib.types.str;
          default = "/dev/disk/by-partlabel/nixos";
          apply = toDevicePath lib;
          description = ''
            The NixOS root *partition* (not the whole disk). Create it in the
            free space left by the Asahi installer:
              sgdisk -n 0:0:0 -c 0:nixos -t 0:8300 /dev/nvme0n1
            or label an existing one with `sgdisk -c <N>:nixos /dev/nvme0n1`.
          '';
        };
        espDevice = lib.mkOption {
          type = lib.types.str;
          example = "/dev/disk/by-uuid/C833-0A0F";
          apply = toDevicePath lib;
          description = ''
            The ESP made by the Asahi installer (m1n1 stage 2, U-Boot,
            vendorfw/firmware.cpio). Mounted at /boot/efi, never formatted.
          '';
        };
      };

    config = {
      boot.loader.efi.efiSysMountPoint = "/boot/efi";

      disko.devices.disk = {
        esp = {
          type = "disk";
          device = cfg.espDevice;
          destroy = false;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot/efi";
            mountOptions = ["fmask=0022" "dmask=0022"];
          };
        };
        root = {
          type = "disk";
          inherit (cfg) device;
          destroy = false;
          content = {
            type = "btrfs";
            # 4K sectors (btrfs-progs default since 6.3, what Fedora Asahi
            # uses). GRUB must read /boot from this filesystem.
            extraArgs = ["-L" "nixos" "--sectorsize" "4096"];
            subvolumes = subvolumes cfg;
          };
        };
      };
    };
  };
}
