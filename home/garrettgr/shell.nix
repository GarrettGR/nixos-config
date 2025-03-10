{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      expireDuplicatesFirst = true;
    };
    
    shellAliases = {
      ll = "eza -la";
      ls = "eza";
      cat = "bat";
      cd = "z";
      vim = "nvim";
      gs = "git status";
      gc = "git commit";
      gd = "git diff";
    };
    
    initExtra = ''
      # Additional zsh configuration
      bindkey '^[[A' up-line-or-search
      bindkey '^[[B' down-line-or-search
    '';
  };
  
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };
  
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };
  
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = true;
      update_check = true;
    };
  };
  
  home.packages = with pkgs; [
    eza
    bat
    bottom
    fd
    fzf
    yazi
    xclip
  ];
  
  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "JetBrainsMono Nerd Font";
      font.size = 12;
    };
  };
}
