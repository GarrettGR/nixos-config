# Baseline configuration applied to every NixOS host. Pulls in the container
# and nix-settings features by name (dendritic) rather than by path.
{config, ...}: {
  flake.modules.nixos.base = {
    lib,
    pkgs,
    ...
  }: {
    imports = [
      config.flake.modules.nixos.containers
      config.flake.modules.nixos.nix-settings
    ];

    system.stateVersion = "25.05";

    environment.systemPackages = with pkgs; [
      vim
      wget
      git
      curl
      htop
      tldr
      ripgrep
      bat
      bitwarden-cli
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      EDITOR = "vim";
    };

    services = {
      openssh.enable = true;
      pcscd.enable = true;
      timesyncd.enable = true;
    };

    security.sudo.wheelNeedsPassword = true;

    i18n.defaultLocale = "en_US.UTF-8";

    time.timeZone = lib.mkDefault "America/New_York";
  };
}
