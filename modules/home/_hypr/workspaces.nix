{lib, ...}: let
  # Launch an app when one of these workspaces is created empty.
  # Replaces the deprecated `on_created_empty` workspace-rule field (Hyprland 0.57+).
  # Keyed by addressable_name, which stays "6" even after default_name renames it to "browser".
  onCreatedEmpty = {
    "6" = "zen-twilight";
    "7" = "legcord";
    "8" = "obsidian";
    "9" = "ghostty";
    "special:obs" = "obs";
  };

  luaTable = lib.concatStringsSep ", " (
    lib.mapAttrsToList (ws: cmd: ''[${builtins.toJSON ws}] = ${builtins.toJSON cmd}'') onCreatedEmpty
  );
in {
  wayland.windowManager.hyprland.settings = {
    on = [
      {
        _args = [
          "workspace.created"
          (lib.generators.mkLuaInline ''
            function(ws)
              local apps = { ${luaTable} }
              if not ws or not ws.is_empty then return end
              local cmd = apps[ws.addressable_name]
              if cmd then hl.exec_cmd(cmd) end
            end
          '')
        ];
      }
    ];

    workspace_rule = [
      {
        workspace = "6";
        default_name = "browser";
        layout = "monocle";
      }
      {
        workspace = "7";
        default_name = "discord";
        layout = "dwindle";
      }
      {
        workspace = "8";
        default_name = "notes";
        layout = "master";
      }
      {
        workspace = "9";
        default_name = "terminal";
        layout = "dwindle";
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
