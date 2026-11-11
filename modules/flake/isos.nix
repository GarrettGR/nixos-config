# Minimal installer ISOs, built standalone (NOT through mkNixos, so no
# home-manager/stylix/etc.). Both carry the `installer` module: a copy of this
# flake, disko, and `install-host`.
#
#   nix build .#iso-x86_64                         # on any x86_64-linux host
#   nix build .#iso-apple-silicon                  # native, on hardin-nix
#   nix build .#packages.x86_64-linux.iso-apple-silicon   # cross-built from x86
#
# The Apple Silicon ISO uses nixos-apple-silicon's own builder and pinned
# nixpkgs (the minimal Asahi installer config + our extraModules).
{
  inputs,
  config,
  lib,
  ...
}: let
  m = config.flake.modules;

  isoX86 =
    (inputs.nixpkgs.lib.nixosSystem {
      modules = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        m.nixos.installer
        m.nixos.nix-caches-cuda # nixos-install builds arrakis/hyperion through these
        {nixpkgs.hostPlatform = "x86_64-linux";}
      ];
    })
    .config
    .system
    .build
    .isoImage;

  # buildSystem: the machine doing the build. "aarch64-linux" = native,
  # "x86_64-linux" = cross-compiled (slow, little binary-cache coverage).
  isoAppleSilicon = buildSystem:
    inputs.apple-silicon-support.lib.mkInstallerBootstrapCustom {
      system = buildSystem;
      extraModules = [m.nixos.installer m.nixos.nix-caches-asahi];
    };
in {
  perSystem = {system, ...}: {
    packages =
      lib.optionalAttrs (system == "x86_64-linux") {
        iso-x86_64 = isoX86;
        iso-apple-silicon = isoAppleSilicon "x86_64-linux";
      }
      // lib.optionalAttrs (system == "aarch64-linux") {
        iso-apple-silicon = isoAppleSilicon "aarch64-linux";
      };
  };
}
