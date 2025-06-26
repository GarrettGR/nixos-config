{
  pkgs,
  inputs,
  ...
}: let
  patchedOverlay = self: super: let
    originalOverlay = inputs.nixos-muvm-fex.overlays.default self super;

    patchMesaFlags = old: {
      mesonFlags = let
        filteredFlags =
          builtins.filter
          (flag: !(builtins.match "-Dtools=.*" flag != null))
          (old.mesonFlags or []);

        filteredFlags2 =
          builtins.filter
          (flag: !(builtins.match ".*libgbm-external.*" flag != null))
          filteredFlags;
      in
        filteredFlags2 ++ ["-Dtools=asahi"];
    };
  in
    originalOverlay {
      mesa-asahi-edge = (originalOverlay.mesa-asahi-edge or super.mesa-asahi-edge).overrideAttrs patchMesaFlags;

      pkgsCross = (originalOverlay.pkgsCross or super.pkgsCross) {
        gnu64 = (originalOverlay.pkgsCross.gnu64 or super.pkgsCross.gnu64) {
          mesa-asahi-edge = (originalOverlay.pkgsCross.gnu64.mesa-asahi-edge or super.pkgsCross.gnu64.mesa-asahi-edge).overrideAttrs patchMesaFlags;
        };
      };
    };
in {
  nixpkgs.overlays = [patchedOverlay];
  environment.systemPackages = with pkgs; [muvm];
}
