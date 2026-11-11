# ghostty is Linux-only in nixpkgs; on darwin it's installed via app/brew, so
# guard this so `core` stays darwin-safe.
{...}: {
  flake.modules.homeManager.ghostty = {
    lib,
    pkgs,
    ...
  }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      programs.ghostty = {
        enable = true;
        enableZshIntegration = true;
        installVimSyntax = true;
        settings = {
          shell-integration = "zsh"; # NOTE: Is this redundant with the option above ??
          window-decoration = "none";
          clipboard-read = "allow";
          clipboard-write = "allow";
          focus-follows-mouse = true;
          confirm-close-surface = false;
          keybind = [
            "clear"
            # clipboard
            "ctrl+shift+c=copy_to_clipboard:mixed"
            "ctrl+shift+v=paste_from_clipboard"
            "copy=copy_to_clipboard:mixed"
            "paste=paste_from_clipboard"
            # font size
            "ctrl+==increase_font_size:1"
            "ctrl++=increase_font_size:1"
            "ctrl+-=decrease_font_size:1"
            # scrollback
            "shift+home=scroll_to_top"
            "shift+end=scroll_to_bottom"
            "shift+page_up=scroll_page_up"
            "shift+page_down=scroll_page_down"
            # selection
            "shift+arrow_up=adjust_selection:up"
            "shift+arrow_down=adjust_selection:down"
            "shift+arrow_left=adjust_selection:left"
            "shift+arrow_right=adjust_selection:right"
            # misc
            "ctrl+shift+p=toggle_command_palette"
            "escape=end_search"
          ];
          # linux-cgroup = "always"; # Linux-only; enable behind pkgs.stdenv.hostPlatform.isLinux if re-adding
          # linux-cgroup-hard-fail = false;
        };
      };
    };
}
