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

  programs.uwsm.enable = true;

  security.pam.services.hyprlock = {};
  security.pam.services.hyprlock.fprintAuth = false;

  environment.systemPackages = with pkgs; [
    eww
    # grim
    # slurp
    wl-clipboard
    wtype
    # networkmanagerapplet
    dunst
    libnotify
    # kdePackages.dolphin
    # nautilus
    vulkan-tools
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
