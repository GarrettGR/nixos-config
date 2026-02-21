{
  pkgs,
  system,
  lib,
  inputs,
  ...
}: let
  pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  services.containers.enableDocker = true;
  environment.systemPackages = with pkgs; [
    moonlight-embedded
    distrobox
    whatsapp-electron
    slacky

    inputs.librepods.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
