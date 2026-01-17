{lib, ...}: {
  wayland.windowManager.hyprland.settings.monitor = lib.mkBefore [
    "desc:Samsung Electric Company SAMSUNG, 3840x2160@60, 0x0, 1.5, cm, auto"
    "eDP-1, 3024x1964@120, 2560x601, 2, cm, auto"
  ];
}
