{
  inputs,
  config,
  ...
}: let
  m = config.flake.modules;

  mkHome = {
    system,
    username ? config.flake.user.name,
    homeDirectory ? "/home/${username}",
    extraModules ? [],
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = {inherit inputs;};
      modules =
        [
          m.homeManager.cli
          m.homeManager.remote
          {
            home.username = username;
            home.homeDirectory = homeDirectory;
            home.stateVersion = "25.05";
          }
        ]
        ++ extraModules;
    };
in {
  flake.homeConfigurations = {
    wulver = mkHome {
      system = "x86_64-linux";
      username = "grg";
    };
    remote-x86_64 = mkHome {system = "x86_64-linux";};
    remote-aarch64 = mkHome {system = "aarch64-linux";};
  };
}
