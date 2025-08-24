{lib, ...}: {
  wayland.windowManager.hyprland.settings.monitor = lib.mkBefore [
    "desc:Samsung Electric Company SAMSUNG, 3840x2160@60, 1280x0, 1, cm, auto"
    "eDP-1, 2560x1664@60, 0x0, 2, cm, auto"
  ];
}
