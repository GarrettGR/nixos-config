{config, ...}: {
  flake.modules.homeManager.cli = {...}: {
    imports = [
      config.flake.modules.homeManager.shell
      config.flake.modules.homeManager.tmux
      config.flake.modules.homeManager.git
    ];

    programs.home-manager.enable = true;
  };
}
