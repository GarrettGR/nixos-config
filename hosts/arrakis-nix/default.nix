# arrakis-nix host-local config. Shared features (base, users, stylix, nvf,
# desktop, gaming, networking, nfs, n8n, …) are attached by the builder.
{
  flakeUser,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
    ./cuda.nix
    ./packages.nix
    ./users.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment.systemPackages = with pkgs; [
    lact
  ];

  networking.hostName = "arrakis-nix";

  services.containers = {
    enableDocker = true;
    enableSingularity = true;
  };

  home-manager.users.${flakeUser.name}.imports = [./home-manager];
}
