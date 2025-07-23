{
  pkgs,
  system,
  lib,
  ...
}: {
  # home.packages = with pkgs; [];

  programs.waybar = {
    settings.mainBar = {
      modules-right = lib.mkBefore [
        "tray"
        "custom/wofi-launcher"
      ];

      tray = {
        icon-size = 12;
        spacing = 4;
        show-passive-items = true;
      };

      "custom/wofi-launcher" = {
        format = "󰍉";
        tooltip = "Launch Applications (wofi)";
        on-click = "${pkgs.wofi}/bin/wofi --show drun";
      };
    };

    style = lib.mkAfter ''
      #tray {
        padding: 0 6px 0 4px;
        color: @base05;
      }
    '';
  };
}
