{lib, ...}: {
  wayland.windowManager.hyprland.settings.monitor = lib.mkBefore [
    "desc:Samsung Electric Company SAMSUNG, 3840x2160@60, 1920x0, 1.6, cm, auto"
    "desc:Dell Inc. DELL SE2222H 622PZG3, 1920x1080@60, 0x0, 1, cm, auto"
    "desc:Telecom Technology Centre Co. Ltd. Woieyeks-DP, 1920x1080@60, 0x0, 1, cm, auto"
  ];
}
