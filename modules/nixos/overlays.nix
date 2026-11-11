# nixpkgs overlays applied to every NixOS host (imported by base).
_: {
  flake.modules.nixos.overlays = _: {
    nixpkgs.overlays = [
      (_: prev:
        # nixpkgs 26.11 made rustPlatform.cargoSetupHook force system C libraries
        # (zstd, aws-lc, openssl, ...) over the crates' vendored copies. These
        # packages don't declare pkg-config/zstd/aws-lc yet and fail to build;
        # opt them out until nixpkgs fixes them upstream.
          prev.lib.genAttrs ["protonup-rs" "asm-lsp" "ncspot"] (
            name: prev.${name}.overrideAttrs {dontCargoUseSystemLibs = true;}
          ))
    ];
  };
}
