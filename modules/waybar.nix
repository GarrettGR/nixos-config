{pkgs, ...}: {
  stylix.targets.waybar = {
    addCss = false;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        margin-top = 1;
        margin-left = 2;
        margin-right = 2;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [];
        modules-right = [
          "pulseaudio"
          "network"
          "tray"
          "clock"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "󰎤";
            "2" = "󰎧";
            "3" = "󰎪";
            "4" = "󰎭";
            "5" = "󰎱";
            "default" = "";
            "discord" = "";
            "browser" = "󰖟";
            "terminal" = "󰆍";
            "obsidian" = "";
          };
          on-click = "activate";
          all-outputs = true;
        };

        clock = {
          format = " {:%H:%M}";
          format-alt = " {:%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B %d}</big>\n<tt><small>{calendar}</small></tt>";
          on-click = "mode";
        };

        network = {
          format-wifi = "󰖩 {essid} ({signalStrength}%)";
          format-ethernet = "󰈀 {ipaddr}/{cidr}";
          format-linked = "󰈀 (No IP)";
          format-disconnected = "󰖪 Disconnected";
          format-alt = "󱛇 {bandwidthUpBits} 󱛋 {bandwidthDownBits}";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          on-click-right = "nm-connection-editor";
        };

        pulseaudio = {
          format = "{icon}:{volume}% {format_source}";
          format-bluetooth = "󰂯:{volume}% {format_source}";
          format-bluetooth-muted = "󰂲 {format_source}";
          format-muted = "󰝟 {format_source}";
          format-source = "󰍬:{volume}%";
          format-source-muted = "󰍭";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰄝";
            car = "󰄋";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        tray = {
          icon-size = 12;
          spacing = 4;
          show-passive-items = true;
        };
      };
    };

    style = ''
      *{
        border: none;
        border-radius: 0;
      }

      .modules-left, .modules-right {
        background-color: alpha(@base00, 0.8);
        border-radius: 10px;
        margin: 0;
        padding: 0 4px 0 2px;
        border: 2px solid alpha(@base0C, 0.5);
      }

      #workspaces button {
        color: @base05;
        padding: 0 4px 0 4px;
        background: transparent;
        box-shadow: none;
        text-shadow: none;
        border-radius: 0;
      }

      #workspaces button.active {
        color: @base0E;
      }

      #workspaces {
        padding: 0 4px 0 0;
      }

      #clock,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 6px 0 4px;
        color: @base05;
      }

      #waybar {
        background: transparent;
      }
    '';
  };
}
