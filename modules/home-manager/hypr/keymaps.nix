{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    bind =
      [
        "SUPER, Q, exec, $terminal"
        "SUPER, R, exec, $menu"

        "SUPER, B, exec, smart-launch $browser browser"
        "SUPER, L, exec, smart-launch Legcord discord"
        "SUPER, O, exec, smart-launch Obsidian notes"

        "SUPER, C, killactive,"
        "SUPER, J, togglesplit,"
        "SUPER, F, togglefloating,"

        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        "SUPER ALT, Q, workspace, name:terminal"
        "SUPER SHIFT, Q, movetoworkspace, name:terminal"
        "SUPER SHIFT, B, movetoworkspace, name:browser"
        "SUPER SHIFT, L, movetoworkspace, name:discord"
        "SUPER SHIFT, O, movetoworkspace, name:notes"

        "SUPER CTRL, S, togglespecialworkspace, scratchpad"
        "SUPER CTRL SHIFT, S, movetoworkspace, special:scratchpad"

        # "SUPER, mouse_down, workspace, e+1"
        # "SUPER, mouse_up, workspace, e-1"

        "SUPER, S, exec, hyprshot -m window -o ~/Pictures/Screenshots/"
        "SUPER SHIFT, S, exec, hyprshot -m region -z --clipboard-only"
      ]
      ++ (
        builtins.concatLists (builtins.genList (
            i: let
              ws = i + 1;
            in [
              "SUPER, code:1${toString i}, workspace, ${toString ws}"
              "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          5)
      );

    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];

    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      "ALT,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+"
      "ALT,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

      ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      "ALT, XF86MonBrightnessUp, exec, brightnessctl -d kbd_backlight s 10%+"
      "ALT, XF86MonBrightnessDown, exec, brightnessctl -d kbd_backlight s 10%-"
    ];

    bindl = [
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };
}
