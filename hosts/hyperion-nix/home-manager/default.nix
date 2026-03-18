{
  pkgs,
  system,
  lib,
  ...
}: {
  imports = [
    # ./plasma.nix
  ];
  services.hypridle.enable = lib.mkForce false;
  services.hyprpaper.enable = lib.mkForce false;
}
