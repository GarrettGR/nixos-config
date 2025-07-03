{
  pkgs,
  system,
  lib,
  ...
}: {
  programs.hyprland.xwayland.enable = lib.mkForce true;

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

    rocmPackages.amdsmi

    protonup-rs
    lutris
    wineWowPackages.waylandFull
  ];

  # START SUNSHINE CONFIG

  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
    autoStart = true;
    # applications = {};
  };

  # secutity.wrappers.sunshine = {
  #   owner = "root";
  #   group = "root";
  #   capabilities = "cap_sys_admin+p";
  #   source = "${pkgs.sunshine}/bin/sunshine";
  # };

  # services.avahi.publish = {
  #   enable = true;
  #   userServices = true;
  # };

  # networking.firewall = {
  #   enable = true;
  #   allowedTCPPorts = [
  #     47984
  #     47989
  #     47990
  #     48010
  #   ];
  #   allowedUDPPortRanges = [
  #     {
  #       from = 47998;
  #       to = 48000;
  #     }
  #     # { from = 8000; to = 8010; }
  #   ];
  # };

  # END SUNSHINE CONFIG

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };
}
