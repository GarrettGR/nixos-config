{config, ...}: let
  # Binary caches, split by audience so hosts only query caches that can
  # actually hit for them (every extra substituter adds a lookup per missing
  # path). Attached as:
  #   nix-caches        : every host (via nix-settings) and both ISOs
  #   nix-caches-asahi  : anything importing the asahi module, Apple ISO
  #   nix-caches-cuda   : arrakis, hyperion, x86 ISO
  caches = {
    general = {
      "https://nix-community.cachix.org" = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
      "https://hyprland.cachix.org" = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
    };
    asahi = {
      "https://nixos-apple-silicon.cachix.org" = "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20=";
    };
    # cache.nixos-cuda.org replaced cuda-maintainers.cachix.org (NixOS CUDA
    # team). cache.flox.dev builds nixpkgs' release-cuda jobset. Both only hit
    # for packages built with stock nixpkgs config (allowUnfree + cudaSupport,
    # default cudaCapabilities).
    cuda = {
      "https://cache.nixos-cuda.org" = "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=";
      "https://cache.flox.dev" = "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=";
    };
  };

  mkCacheModule = set: {lib, ...}: {
    nix.settings = {
      extra-substituters = lib.attrNames set;
      extra-trusted-public-keys = lib.attrValues set;
    };
  };
in {
  flake.modules.nixos.nix-caches = mkCacheModule caches.general;
  flake.modules.nixos.nix-caches-asahi = mkCacheModule caches.asahi;
  flake.modules.nixos.nix-caches-cuda = mkCacheModule caches.cuda;

  flake.modules.nixos.nix-settings = {
    lib,
    pkgs,
    ...
  }: {
    imports = [config.flake.modules.nixos.nix-caches];

    nix = {
      package = lib.mkDefault pkgs.lix;
      settings = {
        trusted-users = [config.flake.user.name];

        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = true;
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
  };
}
