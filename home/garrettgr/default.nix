{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    ./programs/shell.nix
    # ./programs/neovim.nix
    ./programs/tmux.nix
    ./programs/dev.nix
    # ./programs/hyprland.nix
  ];

  home.username = "garrettgr";
  home.homeDirectory = "/home/garrettgr";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Garrett Gonzalez-Rivas";
    userEmail = "grg@njit.edu";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

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
    bitwarden

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
    ghostty
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

    inputs.zen-browser.packages.${system}.twilight
  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
