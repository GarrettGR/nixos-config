{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    terminal = "screen-256color";
    historyLimit = 10000;
    mouse = true;
    keyMode = "vi";

    extraConfig = ''
      set -g status-style bg=black,fg=white
      set -g window-status-current-style bg=white,fg=black,bold

      set -g renumber-windows on
      set -g base-index 1
      setw -g pane-base-index 1

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      set -ga terminal-overrides ",*256col*:Tc"

      set -g status-right '#{cpu_bg_color} CPU: #{cpu_icon} #{cpu_percentage} | %a %h-%d %H:%M '

      # set -g @resurrect-strategy-vim 'session'
      # set -g @resurrect-strategy-nvim 'session'
      # set -g @resurrect-capture-pane-contents 'on'

      # set -g @continuum-restore 'on'
      # set -g @continuum-boot 'on'
      # set -g @continuum-save-interval '10'

      # set-option -g default-command "reattach-to-user-namespace -l $SHELL"
    '';

    plugins = with pkgs; [
      tmuxPlugins.cpu
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
      tmuxPlugins.yank
    ];
  };
}
