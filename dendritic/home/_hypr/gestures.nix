{...}: {
  wayland.windowManager.hyprland.settings = {
    gestures.workspace_swipe_create_new = false;

    gesture = [
      "3, horizontal, workspace"
      "3, down, special, scratchpad"
      "2, pinch, mod: CTRL, cursorZoom, 2.0, live"
    ];
  };
}
