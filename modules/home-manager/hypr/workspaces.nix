{
  config,
  pkgs,
  ...
}: let
  smart-launch = pkgs.writeShellScriptBin "smart-launch" ''
    #!/bin/bash
    APP_COMMAND="$1"
    WORKSPACE_NAME="$2"

    if hyprctl clients | grep -iq "class:.$APP_COMMAND";  then
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
    windowrulev2 = [
      "suppressevent maximize, class:.*"
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

      "workspace name:browser, class:^(zen-alpha|zen-twilight|firefox)$"
      "workspace name:discord, class:^(legcord|discord)$"
      "workspace name:notes, class:^(obsidian)$"
    ];
  };
}
