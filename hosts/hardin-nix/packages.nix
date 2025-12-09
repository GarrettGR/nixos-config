{
  pkgs,
  system,
  lib,
  ...
}: {
  services.containers.enableDocker = true;
  environment.systemPackages = with pkgs; [
    moonlight-embedded
    distrobox
    chromium
  ];
}
