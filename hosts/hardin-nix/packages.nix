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
  services.desktopManager.plasma6.enable = true;
  environment.systemPackages = with pkgs; [
    moonlight-embedded
    distrobox
    whatsapp-electron
    slacky
    jellyfin-desktop
  ];
}
