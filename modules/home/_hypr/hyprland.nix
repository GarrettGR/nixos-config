{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    systemd.enable = false; # needed for UWSM managed sessions

    settings = {
      terminal = {_var = "ghostty";};
      browser = {_var = "zen-twilight";};
      menu = {_var = "wofi --show drun";};

      env = [
        {_args = ["XCURSOR_SIZE" "16"];}
        {_args = ["HYPRCURSOR_SIZE" "24"];}
      ];

      # Also needed for UWSM managed session (because of disabled systemd integration)
      on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''function() hl.exec_cmd("uwsm finalize") end'')
          ];
        }
      ];

      config = {
        general = {
          gaps_in = 3;
          gaps_out = 2;
          border_size = 2;
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        dwindle.preserve_split = true;

        master.new_status = "master";

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        ecosystem.no_update_news = true;

        input = {
          follow_mouse = 1;
          sensitivity = 0;
          touchpad.natural_scroll = true;
        };
      };

      window_rule = [
        {
          name = "picture-in-picture";
          match.initial_title = "^(Picture-in-Picture)$";
          float = true;
          pin = true;
          opacity = "1.0 override 1.0 override 1.0 override";
        }
      ];
    };
  };
}
