{
  pkgs,
  system,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
  ];

  virtualisation.docker.enable = true;
}
