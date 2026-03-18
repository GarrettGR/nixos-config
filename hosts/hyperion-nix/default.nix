{
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./hardware.nix
    # ./cuda.nix
    ./packages.nix
    # ../../modules/desktop.nix
    # ../../modules/packages.nix
    ../../modules/networking.nix
    ../../modules/filesystems.nix
    # ../../modules/nfs.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment.systemPackages = with pkgs; [
    # lact
  ];

  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  services.logind.settings.Login = {
    IdleAction = "ignore";
    HandleSuspendKey = "ignore";
    HandleHibernateKey = "ignore";
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };

  services.containers = {
    enableDocker = true;
    enableSingularity = false;
  };

  # i18n = {
  #   defaultLocale = "en_US.UTF-8";
  #   supportedLocales = [ "en_US.UTF-8" ];
  # };
}
