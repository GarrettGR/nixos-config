# Extras layered on top of both installer ISOs (see flake/isos.nix):
#   - a writable copy of this flake at ~nixos/nixos-config on the live ISO;
#     `install-host` puts it at /etc/nixos/nixos-config on the installed system
#   - binary caches, disko + partitioning tools
#   - `install-host <host>`: disko format/mount + nixos-install for a host
#
# No `specialArgs` here: the Apple Silicon ISO builder only passes
# `modulesPath`, so everything comes from the flake-parts closure.
{
  inputs,
  config,
  ...
}: let
  isoFlakePath = "/home/nixos/nixos-config"; # live ISO (user `nixos`)
  flakePath = "/etc/nixos/nixos-config"; # installed systems
in {
  flake.modules.nixos.installer = {
    lib,
    pkgs,
    ...
  }: let
    install-host = pkgs.writeShellApplication {
      name = "install-host";
      runtimeInputs = with pkgs; [coreutils jq disko];
      text = ''
        if [ "$(id -u)" -ne 0 ]; then
          exec sudo -- "$0" "$@"
        fi

        FLAKE=${isoFlakePath}
        host="''${1:-}"
        if [ -z "$host" ]; then
          echo "usage: install-host <host>" >&2
          echo "hosts:" >&2
          nix eval --json "$FLAKE#nixosConfigurations" --apply builtins.attrNames | jq -r '.[]' >&2
          exit 1
        fi

        disks=$(nix eval --json "$FLAKE#nixosConfigurations.$host.config" --apply \
          'c: if c ? disko then builtins.mapAttrs (_: d: { inherit (d) device destroy; }) c.disko.devices.disk else {}')

        if [ "$(jq 'length' <<<"$disks")" -eq 0 ]; then
          echo "'$host' has no disko layout (add m.nixos.disko-btrfs or disko-asahi to it)." >&2
          echo "Partition and mount under /mnt manually, then run:" >&2
          echo "  nixos-install --no-root-passwd --flake $FLAKE#$host" >&2
          exit 1
        fi

        if jq -e 'any(.[]; .destroy)' <<<"$disks" >/dev/null; then
          mode="destroy,format,mount"
          echo "!! The following disks will be WIPED and repartitioned:"
        else
          mode="format,mount"
          echo "The following devices will be formatted (only if they have no filesystem) and mounted:"
        fi
        jq -r 'to_entries[] | "  \(.key): \(.value.device)  (destroy=\(.value.destroy))"' <<<"$disks"
        echo
        read -r -p "Type the host name ($host) to continue: " answer
        [ "$answer" = "$host" ] || { echo "aborted"; exit 1; }

        disko --mode "$mode" --yes-wipe-all-disks --flake "$FLAKE#$host"

        # Don't clobber an existing copy (e.g. re-installing onto migrated subvolumes).
        if [ -e "/mnt${flakePath}" ]; then
          echo "/mnt${flakePath} already exists; leaving it alone"
        else
          echo "copying flake to /mnt${flakePath}"
          mkdir -p "/mnt$(dirname ${flakePath})"
          cp -rT "$FLAKE" "/mnt${flakePath}"
        fi

        nixos-install --no-root-passwd --flake "$FLAKE#$host"

        echo
        echo "Done. Config is at /mnt${flakePath}; reboot when ready."
      '';
    };
  in {
    imports = [config.flake.modules.nixos.nix-caches];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    environment.systemPackages = with pkgs; [
      install-host
      disko
      git
      jq
      vim
      rsync
      gptfdisk
      btrfs-progs
      dosfstools
    ];

    # Writable copy of this flake (not environment.etc, which is read-only).
    boot.postBootCommands = ''
      if [ ! -e ${isoFlakePath} ]; then
        mkdir -p ${dirOf isoFlakePath}
        cp -rT --no-preserve=mode,ownership ${inputs.self} ${isoFlakePath}
        chown -R nixos:users ${isoFlakePath}
      fi
    '';

    isoImage.squashfsCompression = lib.mkDefault "zstd -Xcompression-level 6";
  };
}
