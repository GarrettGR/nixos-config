{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    "$terminal" = lib.mkForce "alacritty";
  };
  services.hypridle.enable = lib.mkForce false;
}
