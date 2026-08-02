{...}: {
  wayland.windowManager.hyprland.settings = {
    config.gestures.workspace_swipe_create_new = false;

    gesture = [
      {
        fingers = 3;
        direction = "horizontal";
        action = "workspace";
      }
      {
        fingers = 3;
        direction = "down";
        action = "special";
        workspace_name = "scratchpad";
      }
      {
        fingers = 2;
        direction = "pinch";
        mods = "CTRL";
        action = "cursorZoom";
        zoom_level = 2.0;
        mode = "live";
      }
    ];
  };
}
