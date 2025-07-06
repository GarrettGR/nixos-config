{
  description = "GarrettGR's NixOS configuration";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nixpkgs-NUR = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nixpkgs-wayland = {
    #   url = "github:nix-community/nixpkgs-wayland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    hyprland.url = "github:hyprwm/Hyprland";
    # hypr-contrib = {
    #   url = "github:hyprwm/contrib";
    #   inputs.nixpkgs.follows = "hyprland/nixpkgs";
    # };
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
      # url = "github:nix-community/nixos-apple-silicon";
      url = "github:yuyuyureka/nixos-apple-silicon/minimize-patches";

      # url = "github:flokli/nixos-apple-silicon/wip";
      #  inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-muvm-fex.url = "github:nrabulinski/nixos-muvm-fex/native-build";
    nixos-muvm-fex.url = "path:/home/garrettgr/Documents/nixos-muvm-fex";

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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    nvf,
    apple-silicon-support,
    nixos-wsl,
    nixos-muvm-fex,
    zen-browser,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;

    mkSystem = {
      system,
      hostname,
      extraModules ? [],
      extraPkgsConfig ? {},
      extraOverlays ? [],
    }:
      lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs system hostname;};
        pkgs = import inputs.nixpkgs {
          inherit system;
          config =
            {
              allowUnfree = true;
            }
            // extraPkgsConfig;
          overlays = extraOverlays;
        };
        modules =
          [
            ./hosts/${hostname}

            ./modules/base.nix
            ./modules/users.nix
            ./modules/stylix.nix
            ./modules/nvf.nix

            nvf.nixosModules.default
            inputs.stylix.nixosModules.stylix
            # sops-nix.nixosModules.sops
            # nvf.homeManagerModules.defaullt
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit inputs system;};
            }
          ]
          ++ extraModules;
      };
  in {
    nixosConfigurations = {
      seldon-nix = mkSystem {
        system = "aarch64-linux";
        hostname = "seldon-nix";
        extraPkgsConfig = {
          nixos-muvm-fex.mesaDoCross = true;
          allowUnsupportedSystem = true;
        };
        extraOverlays = [
          inputs.nixos-muvm-fex.overlays.default
        ];
        extraModules = [
          ./modules/keyboard.nix
          inputs.titdb.nixosModules.default
          ./modules/titdb.nix
          ./modules/display-manager.nix
          apple-silicon-support.nixosModules.apple-silicon-support
        ];
      };

      rocinante-wsl-nix = mkSystem {
        system = "x86_64-linux";
        hostname = "rocinante-wsl-nix";
        extraModules = [
          nixos-wsl.nixosModules.default
        ];
      };

      arrakis-nix = mkSystem {
        system = "x86_64-linux";
        hostname = "arrakis-nix";
        extraModules = [
          ./modules/keyboard.nix
          ./modules/display-manager.nix
        ];
      };
    };
  };
}
