{
  pkgs,
  system,
  lib,
  inputs,
  ...
}: {
  services.containers.enableDocker = true;
  environment.systemPackages = with pkgs; [
    moonlight-embedded
    distrobox
    chromium
    whatsapp-electron

    inputs.librepods.packages.${pkgs.stdenv.hostPlatform.system}.default

  ];
}
