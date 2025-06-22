{pkgs, ...}: {
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = false;
    withUWSM = true;
  };

  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
  programs.uwsm.enable = true;

  programs.waybar = {
    enable = true;
    # package = pkgs.waybar-hyprland;
  };

  environment.systemPackages = with pkgs; [
    wofi
    eww
    hyprpaper
    hyprshot
    # grim
    # slurp
    brightnessctl
    pavucontrol
    wl-clipboard
    wlogout
    # networkmanagerapplet
    dunst
    libnotify
    # kdePackages.dolphin
    # nautilus
    vulkan-tools
    waypipe
  ];

  programs.firefox.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.monaspace
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.fantasque-sans-mono
    monaspace
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
