# Cloud disk images built from full host configs
{
  config,
  lib,
  ...
}: {
  perSystem = {system, ...}: {
    packages = lib.optionalAttrs (system == "x86_64-linux") {
      image-tycho-nix = config.flake.nixosConfigurations.tycho-nix.config.system.build.digitalOceanImage;
    };
  };
}
