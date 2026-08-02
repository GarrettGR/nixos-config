{...}: let
  mkCurve = name: points: {
    _args = [
      name
      {
        type = "bezier";
        points = points;
      }
    ];
  };

  mkAnim = leaf: speed: bezier: extra:
    {
      inherit leaf speed bezier;
      enabled = true;
    }
    // extra;
in {
  wayland.windowManager.hyprland.settings = {
    config = {
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

      animations.enabled = true;
    };

    curve = [
      (mkCurve "easeOutQuint" [[0.23 1] [0.32 1]])
      (mkCurve "easeInOutCubic" [[0.65 0.05] [0.36 1]])
      (mkCurve "linear" [[0 0] [1 1]])
      (mkCurve "almostLinear" [[0.5 0.5] [0.75 1.0]])
      (mkCurve "quick" [[0.15 0] [0.1 1]])
    ];

    animation = [
      (mkAnim "global" 7 "default" {})
      (mkAnim "border" 3 "easeOutQuint" {})
      (mkAnim "windows" 2 "easeOutQuint" {})
      (mkAnim "windowsIn" 3.1 "easeOutQuint" {style = "popin 87%";})
      (mkAnim "windowsOut" 1 "linear" {style = "popin 87%";})
      (mkAnim "fadeIn" 1 "almostLinear" {})
      (mkAnim "fadeOut" 1 "almostLinear" {})
      (mkAnim "fade" 2 "quick" {})
      (mkAnim "layers" 2 "easeOutQuint" {})
      (mkAnim "layersIn" 3 "easeOutQuint" {style = "fade";})
      (mkAnim "layersOut" 1 "linear" {style = "fade";})
      (mkAnim "fadeLayersIn" 1 "almostLinear" {})
      (mkAnim "fadeLayersOut" 1 "almostLinear" {})
      (mkAnim "workspaces" 1 "almostLinear" {style = "fade";})
      (mkAnim "workspacesIn" 1 "almostLinear" {style = "fade";})
      (mkAnim "workspacesOut" 1 "almostLinear" {style = "fade";})
    ];
  };
}
