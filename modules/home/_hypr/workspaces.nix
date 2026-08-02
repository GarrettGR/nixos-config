{...}: {
  wayland.windowManager.hyprland.settings = {
    workspace_rule = [
      {
        workspace = "6";
        default_name = "browser";
        layout = "monocle";
        on_created_empty = "zen-twilight";
      }
      {
        workspace = "7";
        default_name = "discord";
        layout = "dwindle";
        on_created_empty = "legcord";
      }
      {
        workspace = "8";
        default_name = "notes";
        layout = "master";
        on_created_empty = "obsidian";
      }
      {
        workspace = "9";
        default_name = "terminal";
        layout = "dwindle";
        on_created_empty = "ghostty";
      }
      {
        workspace = "special:obs";
        on_created_empty = "obs";
      }
    ];

    window_rule = [
      {
        name = "suppress-maximize-events";
        match.class = ".*";
        suppress_event = "maximize";
      }
      {
        name = "fix-xwayland-drags";
        match = {
          class = "^$";
          title = "^$";
          xwayland = true;
          float = true;
          fullscreen = false;
          pin = false;
        };
        no_focus = true;
      }
      {
        name = "browser-to-workspace-6";
        match.class = "^(zen-alpha|zen-twilight|firefox|chromium-browser)$";
        workspace = 6;
      }
      {
        name = "chat-to-workspace-7";
        match.class = "^(legcord|discord)$";
        workspace = 7;
      }
      {
        name = "notes-to-workspace-8";
        match.class = "^(obsidian|org.pwmt.zathura)$";
        workspace = 8;
      }
      {
        name = "obs-to-special";
        match.class = "^(com\\.obsproject\\.Studio)$";
        workspace = "special:obs silent";
      }
    ];
  };
}
