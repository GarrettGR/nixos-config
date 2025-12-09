{
  pkgs,
  lib,
  hostname,
  ...
}: {
  imports = [
    ./programs/shell.nix
    ./programs/tmux.nix
    ./programs/dev.nix
    ./programs/git.nix
    # ./programs/hyprland.nix
    ./programs/zen.nix
    ./programs/ghostty.nix
    ../../modules/waybar.nix
    ../../modules/home-manager/hypr
  ];

  home = {
    username = "garrettgr";
    homeDirectory = "/home/garrettgr";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  programs.zathura.enable = true;

  home.packages = with pkgs; [
    spotify-player
    # spotify-cli-linux
    # spotify # spicetify # unavailable on aarch64
    # ytui-music
    psst

    batmon
    keepassxc # look at alternative credential stores (??)

    # tuisky
    # tuir

    # wikitui

    obsidian
    bitwarden-desktop

    legcord
    telegram-desktop
    signal-desktop
    # slacky # FIXME: THIS DOENST WORK (says unsupported browser)
    slack-cli
    # slack-term

    speedread
    nmap
    speedtest-cli
    localsend
    rclone
    fastfetch

    # zed-editor
    jujutsu
    # lazyjj
    # gg-jj

    # darktable
    # kicad
    # freecad-wayland

    # gimp3
    # audacity
    # obs-studio
    # davinci-resolve # davinci-resolve-studio

    # ffmpeg # ffmpeg-full
  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
      config.common.default = "hyprland";
    };
  };
}
