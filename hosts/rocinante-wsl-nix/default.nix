# rocinante-wsl-nix host-local config. The nixos-wsl module is attached by the
# builder; shared base/users/stylix/nvf + home core/linux/zen come from there too.
{flakeUser, ...}: {
  networking.hostName = "rocinante-wsl-nix";

  wsl = {
    enable = true;
    defaultUser = flakeUser.name;
    startMenuLaunchers = true;
    useWindowsDriver = true;
  };
}
