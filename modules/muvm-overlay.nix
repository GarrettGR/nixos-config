{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = let
    pkgsFex = import pkgs.path {
      inherit (pkgs) system;
      config.nixos-muvm-fex.mesaDoCross = true;
      overlays = [inputs.nixos-muvm-fex.overlays.default];
    };
  in [
    pkgsFex.muvm
    pkgsFex.fex
    pkgs.libsForQt5.qt5.qtwayland
  ];
}
