# Builds flake.nixosConfigurations from the named dendritic modules. Each host
# gets the common base (base/users/stylix/nvf + home core), its opted-in feature
# modules, and a host-local leaf (hosts/<name>/default.nix) for hardware and
# host-specific config.
{
  inputs,
  config,
  ...
}: let
  m = config.flake.modules;
  userName = config.flake.user.name;

  mkNixos = {
    system,
    nixosModules ? [],
    homeModules ? [],
    hostModule,
  }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        flakeUser = config.flake.user;
      };
      modules =
        [
          m.nixos.base
          m.nixos.users
          m.nixos.stylix
          m.nixos.nvf
          inputs.home-manager.nixosModules.home-manager
          {
            nixpkgs.hostPlatform = system;
            nixpkgs.config.allowUnfree = true;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
              users.${userName} = {
                imports = [m.homeManager.core] ++ homeModules;
                home.username = userName;
                home.homeDirectory = "/home/${userName}";
                home.stateVersion = "25.05";
              };
            };
          }
          hostModule
        ]
        ++ nixosModules;
    };
in {
  flake.nixosConfigurations = {
    hardin-nix = mkNixos {
      system = "aarch64-linux";
      nixosModules = [
        m.nixos.asahi
        m.nixos.keyboard
        m.nixos.titdb
        m.nixos.display-manager
        m.nixos.ios-usb
        m.nixos.logitech
        m.nixos.desktop
        m.nixos.networking
        m.nixos.packages
        m.nixos.filesystems
        inputs.determinate.nixosModules.default
      ];
      homeModules = [
        m.homeManager.linux
        m.homeManager.desktop
        m.homeManager.waybar-laptop
        m.homeManager.zen
      ];
      hostModule = ../../hosts/hardin-nix;
    };

    arrakis-nix = mkNixos {
      system = "x86_64-linux";
      nixosModules = [
        m.nixos.keyboard
        m.nixos.display-manager
        m.nixos.n8n
        m.nixos.desktop
        m.nixos.gaming
        m.nixos.networking
        m.nixos.nfs
        m.nixos.packages
      ];
      homeModules = [
        m.homeManager.linux
        m.homeManager.desktop
        m.homeManager.zen
      ];
      hostModule = ../../hosts/arrakis-nix;
    };

    hyperion-nix = mkNixos {
      system = "x86_64-linux";
      nixosModules = [
        m.nixos.keyboard
        m.nixos.nixflix
        m.nixos.cloudflare-tunnel
        m.nixos.gaming
        m.nixos.networking
        m.nixos.filesystems
      ];
      homeModules = [
        m.homeManager.linux
        m.homeManager.zen
      ];
      hostModule = ../../hosts/hyperion-nix;
    };

    rocinante-wsl-nix = mkNixos {
      system = "x86_64-linux";
      nixosModules = [
        inputs.nixos-wsl.nixosModules.default
      ];
      homeModules = [
        m.homeManager.linux
        m.homeManager.zen
      ];
      hostModule = ../../hosts/rocinante-wsl-nix;
    };
  };
}
