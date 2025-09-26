{
  lib,
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
    ../../modules/muvm-overlay.nix
    ../../modules/filesystems.nix
  ];

  networking = {
    hostName = "${hostname}";
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
      wifi = {
        backend = lib.mkForce "iwd";
        powersave = true;
      };
    };
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
    gfxmodeEfi = "2560x1664";
  };

  # boot.binfmt.emulatedSystems = ["x86_64-linux"];
  # nix.settings.extra-platforms = ["x86_64-linux"];

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

  services.xserver.videoDrivers = ["displaylink" "modesetting"];

  time.timeZone = "America/New_York";
}
