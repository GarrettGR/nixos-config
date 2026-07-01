{...}: {
  wayland.windowManager.hyprland.settings = {
    decoration = {
      rounding = 10;
      rounding_power = 2;
      active_opacity = 1.0;
      inactive_opacity = 0.85;

      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
      };

      blur = {
        enabled = true;
        size = 3;
        passes = 1;
        vibrancy = 0.1696;
      };
    };

    animations = {
      enabled = true;

      bezier = [
        "easeOutQuint,0.23,1,0.32,1"
        "easeInOutCubic,0.65,0.05,0.36,1"
        "linear,0,0,1,1"
        "almostLinear,0.5,0.5,0.75,1.0"
        "quick,0.15,0,0.1,1"
      ];

      animation = [
        "global, 1, 7, default"
        "border, 1, 3, easeOutQuint"
        "windows, 1, 2, easeOutQuint"
        "windowsIn, 1, 3.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1, linear, popin 87%"
        "fadeIn, 1, 1, almostLinear"
        "fadeOut, 1, 1, almostLinear"
        "fade, 1, 2, quick"
        "layers, 1, 2, easeOutQuint"
        "layersIn, 1, 3, easeOutQuint, fade"
        "layersOut, 1, 1, linear, fade"
        "fadeLayersIn, 1, 1, almostLinear"
        "fadeLayersOut, 1, 1, almostLinear"
        "workspaces, 1, 1, almostLinear, fade"
        "workspacesIn, 1, 1, almostLinear, fade"
        "workspacesOut, 1, 1, almostLinear, fade"
      ];
    };
  };
}
