{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ./packages.nix
    ../../modules/desktop.nix
    ../../modules/packages.nix
    ../../modules/networking.nix
    ../../modules/nfs.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "arrakis-nix";
    networkmanager.enable = true;
  };

  time.timeZone = "America/New_York";

  # i18n = {
  #   defaultLocale = "en_US.UTF-8";
  #   supportedLocales = [ "en_US.UTF-8" ];
  # };
}
