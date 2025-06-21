{
  pkgs,
  system,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    moonlight-embedded # moonlight-qt
    darktable
    kicad
    freecad-wayland
    gimp3
    audacity
    obs-studio
    # davinci-resolve
    (pkgs.callPackage ../../modules/davinci-resolve-paid.nix {})
    # (pkgs.callPackage ../../modules/davinci-resolve-multistage.nix {})
    ffmpeg
    kdePackages.dolphin

    protonup-rs
    lutris
    wineWowPackages.waylandFull
  ];

  services.sunshine = {
    enable = true;
    openFirewall = true;
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
