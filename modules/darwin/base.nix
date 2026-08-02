# Baseline nix-darwin configuration for the Mac.
{config, ...}: {
  flake.modules.darwin.base = {pkgs, ...}: {
    security.pam.services.sudo_local.touchIdAuth = true;

    nix.settings.experimental-features = ["nix-command" "flakes"];

    programs.zsh.enable = true;

    system.stateVersion = 5; # darwin schema version (distinct from NixOS 25.05)
    system.primaryUser = config.flake.user.name;

    nixpkgs.hostPlatform = "aarch64-darwin";

    users.users.${config.flake.user.name}.home = "/Users/${config.flake.user.name}";
  };
}
