{pkgs, ...}: {
  stylix.targets.waybar = {
    addCss = false;
  };

  programs.waybar = {
    enable = true;
    # package = pkgs.waybar;
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
          "backlight"
          "battery"
          "clock"
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "󰎤";
            "2" = "󰎧";
            "3" = "󰎪";
            "4" = "󰎭";
            "5" = "󰎱";
            "urgent" = "󰀨";
            "default" = "󰎡";
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

        backlight = {
          format = "{icon} {percent}%";
          format-icons = ["󰃞" "󰃟" "󰃠"];
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
        };

        battery = {
          states = {
            good = 75;
            warning = 30;
            critical = 10;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
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
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "󰂯 {volume}%";
          format-bluetooth-muted = "󰂲";
          format-muted = "󰝟";
          format-source = "󰍬 {volume}%";
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
          on-click = "pavucontrol";
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

      /* Notch accommodation - add gap in center */
      .modules-left {
        margin-right: 80px;
      }
      .modules-right {
        margin-left: 80px;
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
      #battery,
      #backlight,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 4px 0 4px;
        color: @base05;
      }

      #battery.charging {
        color: @base0B;
      }

      #battery.warning:not(.charging) {
        color: @base09;
      }

      #battery.critical:not(.charging) {
        color: @base08;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      @keyframes blink {
        to {
          color: @base00;
          background-color: @base08;
        }
      }

      #waybar {
        background: transparent;
      }
    '';
  };
}
