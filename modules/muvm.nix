{
  pkgs,
  system,
  lib,
  inputs,
  ...
}: {
  environment.systemPackages = let
    # pkgsFex = import pkgs.path {
    #   config.nixos-muvm-fex.mesaDoCross = true;
    #   overlays = [inputs.nixos-muvm-fex.overlays.default];
    # };
    pkgsFex = pkgs.extend inputs.nixos-muvm-fex.overlays.default;
  in [pkgsFex.muvm];
}
