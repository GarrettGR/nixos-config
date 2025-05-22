{
  description = "GarrettGR's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # TODO: follow a nixpkgs Wayland option (nix community repo)

    hyprland.url = "github:hyprwm/Hyprland";

    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    }; # NOTE: Do I need this? I could just recreate any community scripts...

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

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

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon-support = {
      # url = "github:tpwrules/nixos-apple-silicon";
      # url = "github:tpwrules/nixos-apple-silicon?rev=f51de44b1d720ac23e838db8e0cf13fadb7942b8";
      url = "github:flokli/nixos-apple-silicon/wip";
      #  inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # obsidian-nvim.url = "github:epwalsh/obsidian.nvim";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.obsidian-nvim.follows = "obsidian-nvim";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    nvf,
    apple-silicon-support,
    zen-browser,
    ...
  } @ inputs: let
    system = "aarch64-linux";
    lib = nixpkgs.lib;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.seldon-nix = lib.nixosSystem {
      inherit system;
      modules = [
        # Host specific configuration
        ./hosts/seldon-nix
        # Import apple silicon support
        apple-silicon-support.nixosModules.apple-silicon-support

        nvf.nixosModules.default
        # nvf.homeManagerModules.default
        # sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.garrettgr = import ./home/garrettgr;
          home-manager.extraSpecialArgs = {inherit inputs system;};
        }

        # Apply common modules
        ./modules/base.nix
        ./modules/users.nix
        ./modules/nvf.nix
        ./modules/display-manager.nix
        ./modules/keyboard.nix
      ];
    };
  };
}
