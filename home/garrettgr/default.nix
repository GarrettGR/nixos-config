{ config, lib, pkgs, inputs, system, ... }:

{
  imports = [
    ./programs/shell.nix
    ./programs/neovim.nix
    ./programs/tmux.nix
    ./programs/dev.nix
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
  
  # Add common user applications
  home.packages = with pkgs; [
    # Productivity
    obsidian
    bitwarden
    
    # Communication
    legcord
    telegram-desktop
    
    # Utilities
    speedread
    nmap
    speedtest-cli
    localsend
    rclone
    fastfetch

    # Development
    zed-editor
    ghostty

    inputs.zen-browser.packages.${system}.default
  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
