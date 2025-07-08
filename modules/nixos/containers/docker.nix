{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.containers;
in {
  config = lib.mkIf cfg.enableDocker {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };

    # TODO: setup / allow GPU pass-through on systems with supported hardware (??)
    # i.e. nvidia container toolkit or something else (??)

    users.users.${cfg.user}.extraGroups = ["docker"];

    environment.systemPackages = with pkgs; [
      docker-compose
      docker-buildx
    ];

    virtualisation.docker.daemon.settings = {
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
    };
  };
}
