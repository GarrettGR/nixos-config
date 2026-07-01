# Builds flake.darwinConfigurations for the Mac (hardin-osx). Mirrors the NixOS
# builder: darwin base/defaults/homebrew + home-manager (core + darwin) via the
# nix-darwin home-manager module. Linux-only home features are simply not
# imported here.
{
  inputs,
  config,
  ...
}: let
  m = config.flake.modules;
  userName = config.flake.user.name;
in {
  flake.darwinConfigurations.hardin-osx = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs;
      flakeUser = config.flake.user;
    };
    modules = [
      m.darwin.base
      m.darwin.defaults
      m.darwin.homebrew
      inputs.home-manager.darwinModules.home-manager
      {
        nixpkgs.config.allowUnfree = true;

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit inputs;};
          users.${userName} = {
            imports = [
              m.homeManager.core
              m.homeManager.darwin
            ];
            home.username = userName;
            home.homeDirectory = "/Users/${userName}";
            home.stateVersion = "24.05";
          };
        };
      }
      ../../hosts/hardin-osx
    ];
  };
}
