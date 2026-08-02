{lib, ...}: let
  inherit (lib.generators) mkLuaInline;

  toggleLayout = ''
    function()
      local ws = hl.get_active_workspace()
      if not ws then return end
      local layout = ws.tiled_layout == "monocle" and "dwindle" or "monocle"
      hl.workspace_rule({ workspace = tostring(ws.id), layout = layout })
    end
  '';

  bind = keys: dispatcher: {
    _args = [keys (mkLuaInline dispatcher)];
  };

  bindWith = keys: dispatcher: opts: {
    _args = [keys (mkLuaInline dispatcher) opts];
  };

  bindRepeat = keys: dispatcher:
    bindWith keys dispatcher {
      locked = true;
      repeating = true;
    };

  bindLocked = keys: dispatcher: bindWith keys dispatcher {locked = true;};

  bindMouse = keys: dispatcher: bindWith keys dispatcher {mouse = true;};

  exec = cmd: "hl.dsp.exec_cmd(${builtins.toJSON cmd})";
in {
  wayland.windowManager.hyprland.settings = {
    bind =
      [
        (bind "SUPER + Q" "hl.dsp.exec_cmd(terminal)")
        (bind "SUPER + R" "hl.dsp.exec_cmd(menu)")

        (bind "XF86LaunchA" toggleLayout)

        (bind "SUPER + B" "hl.dsp.focus({ workspace = 6 })")
        (bind "SUPER + L" "hl.dsp.focus({ workspace = 7 })")
        (bind "SUPER + O" "hl.dsp.focus({ workspace = 8 })")
        (bind "SUPER + CTRL + Q" "hl.dsp.focus({ workspace = 9 })")

        (bind "SUPER + C" "hl.dsp.window.close()")
        (bind "SUPER + F" "hl.dsp.window.float({ action = \"toggle\" })")

        (bind "SUPER + J" "hl.dsp.layout(\"togglesplit\")")
        (bind "SUPER + SHIFT + J" "hl.dsp.layout(\"swapsplit\")")
        (bind "SUPER + CTRL + J" "hl.dsp.layout(\"rotatesplit\")")

        (bind "SUPER + left" "hl.dsp.focus({ direction = \"left\" })")
        (bind "SUPER + right" "hl.dsp.focus({ direction = \"right\" })")
        (bind "SUPER + up" "hl.dsp.focus({ direction = \"up\" })")
        (bind "SUPER + down" "hl.dsp.focus({ direction = \"down\" })")

        (bind "SUPER + period" "hl.dsp.window.cycle_next({ tiled = true })")
        (bind "SUPER + comma" "hl.dsp.window.cycle_next({ tiled = true, prev = true })")

        (bind "SUPER + SHIFT + Q" "hl.dsp.window.move({ workspace = 9 })")
        (bind "SUPER + SHIFT + B" "hl.dsp.window.move({ workspace = 6 })")
        (bind "SUPER + SHIFT + L" "hl.dsp.window.move({ workspace = 7 })")
        (bind "SUPER + SHIFT + O" "hl.dsp.window.move({ workspace = 8 })")

        (bind "SUPER + CTRL + S" "hl.dsp.workspace.toggle_special(\"scratchpad\")")
        (bind "SUPER + CTRL + SHIFT + S" "hl.dsp.window.move({ workspace = \"special:scratchpad\" })")

        (bind "SUPER + CTRL + O" "hl.dsp.workspace.toggle_special(\"obs\")")
        (bind "SUPER + CTRL + SHIFT + O" "hl.dsp.window.move({ workspace = \"special:obs\" })")

        (bind "SUPER + S" (exec "hyprshot -m window -o ~/Pictures/Screenshots/"))
        (bind "SUPER + SHIFT + S" (exec "hyprshot -m region -z --clipboard-only"))
      ]
      ++ (
        builtins.concatLists (builtins.genList (
            i: let
              ws = i + 1;
              key = "code:1${toString i}";
            in [
              (bind "SUPER + ${key}" "hl.dsp.focus({ workspace = ${toString ws} })")
              (bind "SUPER + SHIFT + ${key}" "hl.dsp.window.move({ workspace = ${toString ws} })")
            ]
          )
          5)
      )
      ++ [
        (bindMouse "SUPER + mouse:272" "hl.dsp.window.drag()")
        (bindMouse "SUPER + mouse:273" "hl.dsp.window.resize()")

        (bindRepeat "XF86AudioRaiseVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
        (bindRepeat "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
        (bindRepeat "ALT + XF86AudioRaiseVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+"))
        (bindRepeat "ALT + XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-"))
        (bindRepeat "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
        (bindRepeat "XF86AudioMicMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

        (bindRepeat "XF86MonBrightnessUp" (exec "brightnessctl -e4 -n2 set 5%+"))
        (bindRepeat "XF86MonBrightnessDown" (exec "brightnessctl -e4 -n2 set 5%-"))
        (bindRepeat "ALT + XF86MonBrightnessUp" (exec "brightnessctl -d kbd_backlight s 10%+"))
        (bindRepeat "ALT + XF86MonBrightnessDown" (exec "brightnessctl -d kbd_backlight s 10%-"))

        (bindLocked "XF86AudioNext" (exec "playerctl next"))
        (bindLocked "XF86AudioPause" (exec "playerctl play-pause"))
        (bindLocked "XF86AudioPlay" (exec "playerctl play-pause"))
        (bindLocked "XF86AudioPrev" (exec "playerctl previous"))
      ];
  };
}
