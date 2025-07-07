{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.containers;
in {
  imports = [
    ./docker.nix
    ./singularity.nix
  ];

  options.services.containers = {
    enableDocker = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Docker container runtime";
    };

    enableSingularity = lib.mkOption {
      type = lib.types.bool;
      default = !cfg.enableDocker; # NOTE: default to singularity if docker not enabled
      description = "Enable Singularity container runtime";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "garrettgr";
      description = "User to add to container groups";
    };

    enableBuildTools = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enableDocker;
      description = "Enable container build tools (buildah, podman, etc.)";
    };
  };

  config = {
    warnings =
      []
      ++ lib.optional (!config.users.users ? ${cfg.user}) "Container user '${cfg.user}' does not exist. Container group membership will be skipped.";

    environment.systemPackages = lib.mkIf cfg.enableBuildTools (with pkgs; [
      podman
    ]);
  };
}
