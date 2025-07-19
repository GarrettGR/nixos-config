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
      ];

      tray = {
        icon-size = 12;
        spacing = 4;
        show-passive-items = true;
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
