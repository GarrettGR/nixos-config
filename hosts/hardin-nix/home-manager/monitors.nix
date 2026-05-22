{lib, ...}: {
  wayland.windowManager.hyprland.settings.monitorv2 = lib.mkBefore [
    {
      output = "desc:Samsung Electric Company SAMSUNG";
      mode = "3840x2160@60";
      position = "0x0";
      scale = 1.5;
      cm = "auto";
    }
    {
      output = "desc:RGB Systems Inc. dba Extron Electronics Extron HDMI";
      mode = "1920x1080@60";
      position = "4072x1485";
      scale = 1;
    }
    {
      output = "desc:LG Electronics LG ULTRAWIDE 401NTBK36869";
      mode = "3440x1440@60";
      position = "4072x0";
      scale = 1;
    }
    {
      output = "eDP-1";
      mode = "3024x1964@120";
      position = "2560x601";
      scale = 2;
      cm = "auto";
    }
  ];
}
