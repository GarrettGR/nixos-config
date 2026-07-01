# Cross-platform home baseline: the program modules that work on both NixOS and
# nix-darwin. Linux-only apps/desktop live in home/linux.nix and the desktop
# feature; darwin-only bits live under darwin/. home.username / homeDirectory /
# stateVersion are set per-platform by the host builders.
{config, ...}: {
  flake.modules.homeManager.core = {...}: {
    imports = [
      config.flake.modules.homeManager.shell
      config.flake.modules.homeManager.tmux
      config.flake.modules.homeManager.dev
      config.flake.modules.homeManager.zed
      config.flake.modules.homeManager.git
      config.flake.modules.homeManager.ghostty
    ];

    programs.home-manager.enable = true;
  };
}
