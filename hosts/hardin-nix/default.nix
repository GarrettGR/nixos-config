{
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./hardware.nix
    ./packages.nix
    ../../modules/desktop.nix
    ../../modules/networking.nix
    ../../modules/packages.nix
    ../../modules/filesystems.nix
  ];

  networking.hostName = "${hostname}";

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
    gfxmodeEfi = "2560x1664";
  };

  hardware.asahi.peripheralFirmwareDirectory = /etc/nixos/firmware;

  environment.systemPackages = with pkgs; [
    asahi-btsync
    asahi-wifisync
    # asahi-nvram
    # asahi-bless
    mesa
    alsa-utils
    # alsaequal
    lxqt.pavucontrol-qt
  ];

  services = {
    xserver.videoDrivers = ["displaylink" "modesetting"];
    automatic-timezoned.enable = true;
  };
}
