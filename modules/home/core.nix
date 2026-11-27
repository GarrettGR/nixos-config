{config, ...}: {
  flake.modules.homeManager.core = {pkgs, ...}: {
    imports = [
      config.flake.modules.homeManager.cli
      config.flake.modules.homeManager.dev
      config.flake.modules.homeManager.toolchains
      config.flake.modules.homeManager.dev-gui
      config.flake.modules.homeManager.zed
      config.flake.modules.homeManager.ghostty
    ];

    # Workstation-only CLI helpers; deliberately not in dev, so clusters skip them.
    home.packages = with pkgs; [
      yq
      tldr
      tio
    ];
  };
}
