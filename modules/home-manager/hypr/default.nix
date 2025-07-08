{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./core.nix
    # ./monitors.nix
    # ./visuals.nix
    # ./keymaps.nix
    # ./workspaces.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
  ];

  home.file.".config/hypr/wallpaper.jpg" = lib.mkIf (!builtins.pathExists "${config.home.homeDirectory}/.config/hypr/wallpaper.jpg") {
    source = ../../../assets/wallpaper.jpg;
  };

  home.packages = with pkgs; [
    hyprland
    hyprpaper
    hyprlock
    hypridle
    hyprshot

    wofi
    brightnessctl
    playerctl
    wireplumber
  ];
}
