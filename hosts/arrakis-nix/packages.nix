{
  pkgs,
  system,
  lib,
  ...
}: {
  programs.hyprland.xwayland.enable = lib.mkForce true;

  environment.systemPackages = with pkgs; [
    # darktable
    # kicad
    # freecad-wayland
    gimp3
    audacity
    obs-studio
    # davinci-resolve
    (pkgs.callPackage ../../modules/davinci-resolve-paid.nix {})
    # (pkgs.callPackage ../../modules/davinci-resolve-multistage.nix {})
    ffmpeg

    alacritty
    kdePackages.dolphin

    rocmPackages.amdsmi

    protonup-rs
    lutris
    wineWowPackages.waylandFull
  ];

  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
    autoStart = true;
    # applications = {};
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };
}
