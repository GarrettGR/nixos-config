{
  pkgs,
  lib,
  ...
}: let
  auto-monitor = pkgs.writeShellScriptBin "auto-monitor" ''
    #!/bin/bash

    if hyprctl monitors | grep -q -E "(Samsung|Dell|ASUS)"; then # TODO: generalize this to all external monitors?
        hyprctl keyword monitor "eDP-1,disable"
    else
        hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
    fi
  '';

  monitor-daemon = pkgs.writeShellScriptBin "monitor-daemon" ''
    #!/bin/bash

    echo "Starting monitor daemon..."

    hyprctl events | while read -r event; do
        if echo "$event" | grep -q -E "(monitoradded|monitorremoved)"; then
            echo "Monitor event detected: $event"
            sleep 0.5
            auto-monitor
        fi
    done
  '';
in {
  home.packages = [auto-monitor monitor-daemon];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "desc:Samsung Electric Company SAMSUNG, 1920x1080@60, 1920x0, 1, cm, auto"
      "desc:Dell Inc. DELL SE2222H 622PZG3, 1920x1080@60, 0x0, 1, cm, auto"
      "desc:ASUSTek COMPUTER INC VG279QR N5LMQS176221, 1920x1080@120, 0x334, 1, cm, auto"

      "eDP-1, 1920x1080@60, 0x0, 1"
    ];

    exec-once = [
      "auto-monitor"
      "monitor-daemon"
    ];

    bind = lib.mkAfter ["SUPER SHIFT, M, exec, auto-monitor"];
  };
}
