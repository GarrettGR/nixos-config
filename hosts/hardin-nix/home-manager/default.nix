{
  pkgs,
  system,
  lib,
  ...
}: {
  imports = [
    ./waybar.nix
    ./monitors.nix
    # ./kanshi.nix
  ];
}
