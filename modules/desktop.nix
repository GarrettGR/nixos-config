{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.hyprland;
    settings = {
      monitor = [
        "DVI-I-1,3840x2160@60,0x0,1"         # External monitor (right)
        "eDP-1,2560x1664@60,3840x0,2"        # MacBook display (left)
      ];
      
      general = {
        border_size = 2;
        "col.active_border" = "rgba(33ccffee)";
        "col.inactive_border" = "rgba(595959aa)";
        gaps_in = 5;
        gaps_out = 10;
        layout = "dwindle";
      };
      
      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORM,wayland"
        "GDK_BACKEND,wayland,x11"
      ];
      
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          drag_lock = true;
        };
        sensitivity = 0.0;
      };
      
      windowrule = [
        "float,^(pavucontrol)$"
        "float,^(blueman-manager)$"
        "float,^(nm-connection-editor)$"
      ];
      
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      master = {
        new_is_master = true;
      };
      
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };
      
      bind = [
        "SUPER,Q,exec,ghostty"
        "SUPER,C,killactive,"
        "SUPER,M,exit,"
        "SUPER,E,exec,firefox"
        "SUPER,F,togglefloating,"
        "SUPER,SPACE,exec,wofi --show drun"
        "SUPER,P,pseudo,"
        "SUPER,J,togglesplit,"
        
        "SUPER,S,exec,hyprshot -m region --clipboard-only"
        "SUPER_SHIFT,S,exec,hyprshot -m output --clipboard-only"
        
        "SUPER,left,movefocus,l"
        "SUPER,right,movefocus,r"
        "SUPER,up,movefocus,u"
        "SUPER,down,movefocus,d"
        
        "SUPER,1,workspace,1"
        "SUPER,2,workspace,2"
        "SUPER,3,workspace,3"
        "SUPER,4,workspace,4"
        "SUPER,5,workspace,5"
        "SUPER,6,workspace,6"
        "SUPER,7,workspace,7"
        "SUPER,8,workspace,8"
        "SUPER,9,workspace,9"
        "SUPER,0,workspace,10"
        
        "SUPER_SHIFT,1,movetoworkspace,1"
        "SUPER_SHIFT,2,movetoworkspace,2"
        "SUPER_SHIFT,3,movetoworkspace,3"
        "SUPER_SHIFT,4,movetoworkspace,4"
        "SUPER_SHIFT,5,movetoworkspace,5"
        "SUPER_SHIFT,6,movetoworkspace,6"
        "SUPER_SHIFT,7,movetoworkspace,7"
        "SUPER_SHIFT,8,movetoworkspace,8"
        "SUPER_SHIFT,9,movetoworkspace,9"
        "SUPER_SHIFT,0,movetoworkspace,10"
        
        "SUPER,mouse_down,workspace,e+1"
        "SUPER,mouse_up,workspace,e-1"

        "SUPER_SHIFT,left,movecurrentworkspacetomonitor,eDP-1"
        "SUPER_SHIFT,right,movecurrentworkspacetomonitor,DVI-I-1"
      ];
      
      bindm = [
        "SUPER,mouse:272,movewindow" # LMB
        "SUPER,mouse:273,resizewindow" # RMB
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      
      timeouts = [
        {
          timeout = 300;
          command = "hyprlock";
        }
        {
          timeout = 600;
          command = "hyprctl dispatch dpms off";
        }
        {
          timeout = 1800;
          command = "systemctl suspend";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };
      
      background = {
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
        blur_size = 7;
      };
      
      input-field = {
        monitor = "";
        size = "200, 50";
        outline_thickness = 3;
        dots_size = 0.2;
        dots_spacing = 0.64;
        outer_color = "rgb(151515)";
        inner_color = "rgb(200, 200, 200)";
        font_color = "rgb(10, 10, 10)";
        fade_on_empty = true;
        placeholder_text = "<i>Password...</i>";
        hide_input = false;
        position = "0, -80";
        halign = "center";
        valign = "center";
      };
    };
  };

  programs.waybar = {
    enable = true;
    # package = pkgs.waybar-hyprland;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        
        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "battery"
        ];
        
        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          sort-by-number = true;
        };
        
        "hyprland/window" = {
          max-length = 50;
          separate-outputs = true;
        };
        
        "tray" = {
          spacing = 10;
        };
        
        "cpu" = {
          format = " {usage}%";
          tooltip = true;
        };
        
        "memory" = {
          format = " {}%";
        };
        
        "temperature" = {
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" ""];
        };
        
        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };
        
        "network" = {
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ipaddr}/{cidr}";
          tooltip-format = " {ifname} via {gwaddr}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-bluetooth-muted = " {icon} ";
          format-muted = " ";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
      };
    };
    
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(21, 18, 27, 0.9);
        color: #cdd6f4;
      }

      tooltip {
        background: #1e1e2e;
        border-radius: 10px;
        border-width: 2px;
        border-style: solid;
        border-color: #11111b;
      }

      #workspaces button {
        padding: 5px;
        color: #a6adc8;
        margin-right: 5px;
      }

      #workspaces button.active {
        color: #f5c2e7;
        background: #313244;
        border-radius: 10px;
      }

      #workspaces button:hover {
        background: #11111b;
        color: #cdd6f4;
        border-radius: 10px;
      }

      #custom-language,
      #custom-updates,
      #custom-caffeine,
      #custom-weather,
      #window,
      #battery,
      #pulseaudio,
      #network,
      #workspaces,
      #tray,
      #temperature,
      #cpu,
      #memory {
        background: #1e1e2e;
        padding: 0px 10px;
        margin: 3px 0px;
        margin-top: 10px;
        border: 1px solid #181825;
      }

      #temperature.critical {
        color: #e92d4d;
      }

      #workspaces {
        padding-right: 0px;
        padding-left: 5px;
      }

      #window {
        margin-left: 10px;
        margin-right: 10px;
      }

      #network {
        color: #89b4fa;
        border-radius: 10px 0px 0px 10px;
      }

      #memory {
        color: #a6e3a1;
      }

      #cpu {
        color: #f38ba8;
      }

      #tray {
        border-radius: 10px;
        margin-right: 10px;
      }

      #battery {
        color: #f9e2af;
        border-radius: 0px 10px 10px 0px;
        margin-right: 10px;
      }

      #battery.charging,
      #battery.plugged {
        color: #a6e3a1;
      }

      #battery.critical:not(.charging) {
        background-color: #f38ba8;
        color: #1e1e2e;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #pulseaudio {
        color: #89b4fa;
      }

      #pulseaudio.muted {
        color: #f38ba8;
      }
    '';
  };

  environment.systemPackages = with pkgs; [
    # wofi                      # Application launcher
    hyprpaper                 # Wallpaper manager
    hyprshot                  # Screenshot utility
    # grim                      # Screenshot backend
    # slurp                     # Area selection
    wl-clipboard              # Wayland clipboard utilities
    brightnessctl             # Brightness control
    pavucontrol               # PulseAudio volume control
    networkmanagerapplet      # Network manager applet
    libnotify                 # Desktop notifications
    # swaynotificationcenter    # Notification daemon
    # swaylock-effects          # Screen locker
    wlogout                   # Logout menu
    dunst                     # Notification daemon
    # swaybg                    # Wallpaper utility
    rofi-wayland              # Application launcher (alternative)
  ];

  programs.firefox.enable = true;
  
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.monaspace
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.fantasque-sans-mono
    monaspace
    font-awesome
    material-design-icons
  ];
  
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
