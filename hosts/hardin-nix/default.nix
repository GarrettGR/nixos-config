# hardin-nix host-local config. Shared features (base, users, stylix, nvf, asahi,
# desktop, networking, titdb, …) are attached by modules/flake/hosts-nixos.nix.
{
  flakeUser,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
    ./packages.nix
  ];

  networking.hostName = "hardin-nix";

  # determinate provides nix; keep it instead of the lix default from nix-settings.
  nix.package = lib.mkDefault pkgs.nix;

  home-manager.users.${flakeUser.name}.imports = [./home-manager];
}
