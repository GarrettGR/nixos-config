# hardin-osx host-local config. Shared darwin features (base, defaults,
# homebrew) and home (core, darwin) are attached by modules/flake/hosts-darwin.nix.
{...}: {
  networking.hostName = "hardin-osx";
  networking.computerName = "hardin-osx";
}
