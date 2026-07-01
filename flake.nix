{
  description = "GarrettGR's NixOS configuration";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Dendritic pattern framework.
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # impermanence.url = "github:nix-community/impermanence";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    apple-silicon-support = {
      url = "github:nix-community/nixos-apple-silicon";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # obsidian-nvim.url = "github:epwalsh/obsidian.nvim";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.obsidian-nvim.follows = "obsidian-nvim";
    };

    titdb = {
      url = "github:garrettgr/titdb-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    nixflix.url = "github:kiriwalawren/nixflix";
  };

  # Dendritic entry point: flake-parts + import-tree over ./dendritic (the
  # migration-in-progress tree; renamed to ./modules at the Phase 4 cutover).
  #
  # The legacy `mkSystem` block below still builds the live fleet from the
  # untouched ./modules tree and is retired in Phase 4 once
  # dendritic/flake/hosts-nixos.nix takes over flake.nixosConfigurations.
  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      imports = [(inputs.import-tree ./dendritic)];

      flake.nixosConfigurations = let
        lib = inputs.nixpkgs.lib;

        mkSystem = {
          system,
          hostname,
          extraModules ? [],
        }:
          lib.nixosSystem {
            specialArgs = {inherit inputs system hostname;};
            pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            modules =
              [
                ./hosts/${hostname}

                ./modules/base.nix
                ./modules/users.nix
                ./modules/stylix.nix
                ./modules/nvf.nix

                inputs.nvf.nixosModules.default
                inputs.stylix.nixosModules.stylix
                # sops-nix.nixosModules.sops
                inputs.home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.extraSpecialArgs = {inherit inputs system;};
                }
              ]
              ++ extraModules;
          };
      in {
        seldon-nix = mkSystem {
          system = "aarch64-linux";
          hostname = "seldon-nix";
          extraModules = [
            ./modules/keyboard.nix
            inputs.titdb.nixosModules.default
            ./modules/titdb.nix
            ./modules/display-manager.nix
            inputs.apple-silicon-support.nixosModules.apple-silicon-support
          ];
        };

        hardin-nix = mkSystem {
          system = "aarch64-linux";
          hostname = "hardin-nix";
          extraModules = [
            ./modules/keyboard.nix
            inputs.titdb.nixosModules.default
            inputs.determinate.nixosModules.default
            ./modules/titdb.nix
            ./modules/display-manager.nix
            ./modules/ios_usb.nix
            inputs.apple-silicon-support.nixosModules.apple-silicon-support
            # ./modules/linux-asahi-fairydust.nix
            ./modules/logitech.nix
          ];
        };

        rocinante-wsl-nix = mkSystem {
          system = "x86_64-linux";
          hostname = "rocinante-wsl-nix";
          extraModules = [
            inputs.nixos-wsl.nixosModules.default
          ];
        };

        arrakis-nix = mkSystem {
          system = "x86_64-linux";
          hostname = "arrakis-nix";
          extraModules = [
            ./modules/keyboard.nix
            ./modules/display-manager.nix
            ./modules/n8n.nix
          ];
        };

        hyperion-nix = mkSystem {
          system = "x86_64-linux";
          hostname = "hyperion-nix";
          extraModules = [
            ./modules/keyboard.nix
            # ./modules/display-manager.nix
            inputs.nixflix.nixosModules.default
            ./modules/nixflix.nix
            ./modules/cloudflare_tunnel.nix
          ];
        };
      };
    });
}
