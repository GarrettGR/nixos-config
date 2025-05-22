{
  config,
  lib,
  pkgs,
  ...
}: {
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
      c = "clear";
      l = "command ls -l";
      ls = "eza $eza_params";
      ll = "eza --all --header --long $eza_params";
      la = "eza --all $eza_params";
      lt = "eza --icons --tree --color-scale --git --level=3";
      lr = "eza --recurse --level=2 $eza_params";
      cat = "bat";
      ccat = "command cat";
      top = "btop";
      rl = "exec zsh";
      gs = "git status";
      gc = "git commit";
      gd = "git diff";
    };

    initContent = ''
      bindkey '^[[A' up-line-or-search
      bindkey '^[[B' down-line-or-search

      # any-nix-shell zsh --info-right | source /dev/stdin
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
    # any-nix-shell
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "JetBrainsMono Nerd Font";
      font.size = 12;
    };
  };
}
