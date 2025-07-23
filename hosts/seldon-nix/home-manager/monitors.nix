{lib, ...}: {
  wayland.windowManager.hyprland.settings.monitor = lib.mkBefore [
    "desc:Samsung Electric Company SAMSUNG, 2560x1440@60, 1920x0, 1, cm, auto" # NOTE: This doesn't scale evenly, but looks the best on displaylink (MBA can't run it at 4k)
    "desc:Dell Inc. DELL SE2222H 622PZG3, 1920x1080@60, 0x0, 1, cm, auto"
    "eDP-1, 2560x1664@60, 0x0, 2, cm, auto"
  ];
}
