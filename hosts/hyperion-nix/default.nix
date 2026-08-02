# hyperion-nix host-local config (headless media server). Shared features (base,
# users, stylix, nvf, nixflix, cloudflare-tunnel, gaming, networking, …) are
# attached by the builder. Runs Plasma (host-local), not the shared hypr desktop.
{
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
    ./packages.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "hyperion-nix";

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
}
