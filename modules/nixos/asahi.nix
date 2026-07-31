# Apple-Silicon / Asahi hardware support, extracted from the former
# hosts/hardin-nix/default.nix (hardin-nix is now the sole Asahi host).
# Self-imports the upstream apple-silicon-support module.
{inputs, ...}: {
  flake.modules.nixos.asahi = {pkgs, ...}: {
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

    environment.systemPackages = with pkgs; [
      asahi-bless
      asahi-btsync
      asahi-wifisync
      mesa
      alsa-utils
      lxqt.pavucontrol-qt
    ];

    services = {
      xserver.videoDrivers = ["displaylink" "modesetting"];
      automatic-timezoned.enable = true;
    };
  };
}
