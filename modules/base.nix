{
  config,
  lib,
  pkgs,
  ...
}: {
  # TODO: move more of the shared configuration imports here and rename to `default.nix`
  imports = [
    ./nixos/containers
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
    timesyncd.enable = true;
  };

  security.sudo.wheelNeedsPassword = true;

  i18n.defaultLocale = "en_US.UTF-8";
}
