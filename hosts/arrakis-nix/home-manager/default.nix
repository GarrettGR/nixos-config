{
  pkgs,
  system,
  lib,
  ...
}: {
  imports = [
    ./waybar.nix
    ./hyprland.nix
    ./monitors.nix
  ];
}
