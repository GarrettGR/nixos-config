{config, ...}: {
  stylix.targets.hyprlock.enable = false;

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = false;
        grace = 10;
      };

      background = [
        {
          monitor = "";
          path = "${config.xdg.cacheHome}/awww-current";
          blur_passes = 3;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "300, 60";
          position = "0, -120";
          halign = "center";
          valign = "center";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.5;
          dots_center = true;
          font_family = "JetBrains Mono";
          font_color = "rgba(242, 243, 244, 0.95)";
          inner_color = "rgba(0, 0, 0, 0.5)";
          outer_color = "rgba(242, 243, 244, 0.4)";
          check_color = "rgba(204, 136, 0, 1.0)";
          fail_color = "rgba(204, 34, 34, 1.0)";
          placeholder_text = "Password...";
          fade_on_empty = false;
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%A, %B %d\")\"";
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 22;
          font_family = "JetBrains Mono";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%-I:%M\")\"";
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 95;
          font_family = "JetBrains Mono Extrabold";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
