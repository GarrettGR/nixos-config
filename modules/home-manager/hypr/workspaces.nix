{
  config,
  pkgs,
  ...
}: let
  smart-launch = pkgs.writeShellScriptBin "smart-launch" ''
    #!/bin/bash
    APP_COMMAND="$1"
    WORKSPACE_NAME="$2"

    if hyprctl clients | grep -iq "match:class .$APP_COMMAND";  then
      hyprctl dispatch workspace "name:$WORKSPACE_NAME" 1> /dev/null
    else
      hyprctl dispatch exec "[workspace name:$WORKSPACE_NAME silent] $APP_COMMAND" 1> /dev/null
      sleep 0.1
      hyprctl dispatch workspace "name:$WORKSPACE_NAME" 1> /dev/null
    fi
  '';
in {
  home.packages = [smart-launch];

  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "suppress_event maximize, match:class .*"
      "no_focus on,match:class ^$,match:title ^$,match:xwayland 1,match:float 1,match:fullscreen 0,match:pin 0"

      "workspace name:browser, match:class ^(zen-alpha|zen-twilight|firefox|chromium-browser)$"
      "workspace name:discord, match:class ^(legcord|discord)$"
      "workspace name:notes, match:class ^(obsidian|org.pwmt.zathura)$"
    ];
  };
}
