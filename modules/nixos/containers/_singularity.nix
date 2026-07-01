# Imported by ../containers.nix; underscore-prefixed so import-tree skips it as a
# standalone flake-parts module. Shares the services.containers option scope.
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
    users.users.${cfg.user}.extraGroups = ["singularity"];
  };
}
