{
  pkgs,
  hostname,
  ...
}: {
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
    hostName = "${hostname}";
    networkmanager.enable = true;
  };

  services.containers.enableDocker = true;
  services.containers.enableSingularity = true;

  time.timeZone = "America/New_York";

  # i18n = {
  #   defaultLocale = "en_US.UTF-8";
  #   supportedLocales = [ "en_US.UTF-8" ];
  # };
}
