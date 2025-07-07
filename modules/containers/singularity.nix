# modules/containers/singularity.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.containers;
in {
  config = lib.mkIf cfg.enableSingularity {
    programs.singularity = {
      enable = true;
      enableFakeroot = true;
    };

    environment.etc."singularity/singularity.conf".text = ''
      allow setuid = yes
      allow pid ns = yes
      enable fusemount = yes
    '';

    # TODO: setup / allow GPU passthrough on systems with supported hardware (??)

    users.groups.singularity = {};
    users.users = lib.mkIf (config.users.users ? ${cfg.user}) {
      ${cfg.user}.extraGroups = ["singularity"];
    };
  };
}
