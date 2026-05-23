{...}: {
  wayland.windowManager.hyprland.settings = {
    workspace = [
      "6, defaultName:browser, layout:monocle, on-created-empty:zen-twilight"
      "7, defaultName:discord, layout:dwindle, on-created-empty:legcord"
      "8, defaultName:notes, layout:master, on-created-empty:obsidian"
      "9, defaultName:terminal, layout:dwindle, on-created-empty:ghostty"
      "special:obs, on-created-empty:obs"
    ];

    windowrule = [
      "suppress_event maximize, match:class .*"
      "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
      "workspace 6, match:class ^(zen-alpha|zen-twilight|firefox|chromium-browser)$"
      "workspace 7, match:class ^(legcord|discord)$"
      "workspace 8, match:class ^(obsidian|org.pwmt.zathura)$"
      "workspace special:obs silent, match:class ^(com\\.obsproject\\.Studio)$"
    ];
  };
}
