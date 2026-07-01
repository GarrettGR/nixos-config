# System list + per-system pkgs (allowUnfree) and formatter for the flake's
# perSystem outputs. NixOS/darwin configurations set their own nixpkgs; this
# governs `nix fmt`, checks, devShells, and any future perSystem outputs.
{inputs, ...}: {
  systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    formatter = inputs.nixpkgs.legacyPackages.${system}.alejandra;
  };
}
