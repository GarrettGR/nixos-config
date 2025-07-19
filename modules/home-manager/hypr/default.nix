{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hyprland.nix
    ./monitors.nix
    ./visuals.nix
    ./keymaps.nix
    ./workspaces.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
  ];

  home.packages = with pkgs; [
    hyprland
    hyprpaper
    hyprlock
    hypridle
    hyprshot

    wofi
    wlogout
    brightnessctl
    playerctl
    wireplumber
    waypipe
    pavucontrol
  ];
}
