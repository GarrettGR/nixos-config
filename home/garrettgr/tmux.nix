{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a"; # Set prefix to ctrl+a
    terminal = "screen-256color";
    historyLimit = 10000;
    mouse = true;
    keyMode = "vi";

    extraConfig = ''
      # Status bar configuration
      set -g status-style bg=black,fg=white
      set -g window-status-current-style bg=white,fg=black,bold
      
      # Automatically renumber windows
      set -g renumber-windows on
      
      # Start window numbering at 1
      set -g base-index 1
      
      # Start pane numbering at 1
      setw -g pane-base-index 1
      
      # Split panes using | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      
      # Reload config with prefix+r
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      
      # Vim-like pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Enable true color support
      set -ga terminal-overrides ",*256col*:Tc"
    '';

    plugins = with pkgs; [
      tmuxPlugins.cpu
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
      tmuxPlugins.yank
    ];
  };
}
