{lib, ...}: {
  wayland.windowManager.hyprland.settings.monitorv2 = lib.mkBefore [
    {
      output = "desc:Samsung Electric Company SAMSUNG";
      mode = "3840x2160@60";
      position = "1920x0";
      scale = 1.6;
      cm = "auto";
    }
    {
      output = "desc:Dell Inc. DELL SE2222H 622PZG3";
      mode = "1920x1080@60";
      position = "0x0";
      scale = 1;
      cm = "auto";
    }
    {
      output = "desc:Telecom Technology Centre Co. Ltd. Woieyeks-DP";
      mode = "1920x1080@60";
      position = "0x0";
      scale = 1;
      cm = "auto";
    }
  ];
}
