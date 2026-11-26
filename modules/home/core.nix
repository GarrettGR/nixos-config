{config, ...}: {
  flake.modules.homeManager.core = {...}: {
    imports = [
      config.flake.modules.homeManager.cli
      config.flake.modules.homeManager.dev
      config.flake.modules.homeManager.toolchains
      config.flake.modules.homeManager.dev-gui
      config.flake.modules.homeManager.zed
      config.flake.modules.homeManager.ghostty
    ];
  };
}
