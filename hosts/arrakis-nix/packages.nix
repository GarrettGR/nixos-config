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
  ];

  services.sunshine = {
    enable = true;
    openFirewall = true;
    # applications = {};
  };
}
