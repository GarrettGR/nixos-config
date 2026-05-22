{lib, ...}: {
  wayland.windowManager.hyprland.settings.monitorv2 = lib.mkBefore [
    {
      # NOTE: This doesn't scale evenly, but looks the best on displaylink (MBA can't run it at 4k)
      output = "desc:Samsung Electric Company SAMSUNG";
      mode = "2560x1440@60";
      position = "1920x0";
      scale = 1;
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
      output = "eDP-1";
      mode = "2560x1664@60";
      position = "0x0";
      scale = 2;
      cm = "auto";
    }
  ];
}
