{
  pkgs,
  system,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    darktable
    kicad
    freecad-wayland
    gimp3
    audacity
    obs-studio
    davinci-resolve
    ffmpeg
  ];
}
