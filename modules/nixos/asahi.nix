{inputs, ...}: {
  flake.modules.nixos.asahi = {pkgs, ...}: let
    wifi-recover = pkgs.writeShellApplication {
      name = "wifi-recover"; # NOTE: reloading the module bumps the phy name
      runtimeInputs = with pkgs; [kmod systemd networkmanager util-linux gnugrep coreutils];
      text = ''
        if [ "$(id -u)" -ne 0 ]; then
          exec sudo -- "$0" "$@"
        fi

        echo -e "stopping NetworkManager and wpa_supplicant\n"
        systemctl stop NetworkManager.service wpa_supplicant.service || true

        echo "unloading brcmfmac"
        failed=0
        for m in brcmfmac_wcc brcmfmac; do
          if grep -q "^$m " /proc/modules; then
            modprobe -r "$m" || failed=1
          fi
        done

        if [ "$failed" -ne 0 ]; then
          echo -e "\ncould not unload brcmfmac; something still holds a reference" >&2
          echo -e "a reboot is required\n" >&2
          systemctl start NetworkManager.service || true
          exit 1
        fi

        sleep 2

        echo "reloading brcmfmac"
        modprobe brcmfmac

        sleep 4

        echo -e "\nrestarting NetworkManager"
        systemctl start NetworkManager.service

        sleep 6

        echo
        nmcli device status | grep -E "DEVICE|wifi" || true

        echo -e "\nrecent firmware messages:\n"
        dmesg | grep -iE "brcmf" | tail -n 8 || true
      '';
    };
  in {
    imports = [inputs.apple-silicon-support.nixosModules.apple-silicon-support];

    hardware.asahi.enable = true;

    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      gfxmodeEfi = "2560x1664";
    };

    hardware.asahi.peripheralFirmwareDirectory = /etc/nixos/firmware;

    environment.systemPackages =
      (with pkgs; [
        asahi-bless
        asahi-btsync
        asahi-wifisync
        mesa
        alsa-utils
        lxqt.pavucontrol-qt
      ])
      ++ [wifi-recover];

    services = {
      xserver.videoDrivers = ["displaylink" "modesetting"];
      automatic-timezoned.enable = true;
    };
  };
}
