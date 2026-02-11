{
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./hardware.nix
    ./cuda.nix
    # ./rocm.nix
    ./packages.nix
    ./users.nix
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

  environment.systemPackages = with pkgs; [
    lact
  ];

  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
  };

  services.containers = {
    enableDocker = true;
    enableSingularity = true;
  };


  # i18n = {
  #   defaultLocale = "en_US.UTF-8";
  #   supportedLocales = [ "en_US.UTF-8" ];
  # };
}
