{
  pkgs,
  system,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    brightnessctl
    playerctl
    lxqt.pavucontrol-qt
  ];

  programs.waybar = {
    settings.mainBar = {
      modules-right = lib.mkAfter [
        "backlight"
        "battery"
      ];

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

      pulseaudio.on-click = lib.mkForce "${pkgs.lxqt.pavucontrol-qt}/bin/pavucontrol-qt";
    };

    style = lib.mkAfter ''
      .modules-left {
        margin-right: 80px;
      }
      .modules-right {
        margin-left: 80px;
      }

      #battery,
      #backlight {
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
    '';
  };
}
