# arrakis-nix host-local packages. Steam + Sunshine now live in the shared
# gaming module; this keeps the creative/compute tooling and the xwayland tweak.
{
  pkgs,
  inputs,
  lib,
  ...
}: let
  pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  programs.hyprland.xwayland.enable = lib.mkForce true;

  environment.systemPackages = with pkgs; [
    gimp3
    audacity
    obs-studio
    ffmpeg

    kompute
    mkl
    sycl-info
    adaptivecpp

    distcc
    mpi
    mpich
    blas

    (pkgs-stable.taco)

    gpu-viewer
    nvtopPackages.full

    alacritty
    kdePackages.dolphin

    distrobox

    protonup-rs
    lutris
  ];
}
