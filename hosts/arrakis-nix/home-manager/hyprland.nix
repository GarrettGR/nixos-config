{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    "$terminal" = lib.mkForce "alacritty";
  };
}
