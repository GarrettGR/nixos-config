# The primary-user account. Home-manager wiring lives in the host builders
# (flake/hosts-{nixos,darwin}.nix), which attach the shared homeManager modules
# per platform.
{config, ...}: {
  flake.modules.nixos.users = {pkgs, ...}: {
    users = {
      mutableUsers = false;
      users.${config.flake.user.name} = {
        isNormalUser = true;
        hashedPassword = "$y$j9T$aJmECtPF9vQFrrcKekuiC.$GdBTLC1ly84/cIJik7AMhK2iy2lYHLJxvVe3ywu9wr8";
        shell = pkgs.zsh;
        extraGroups = config.flake.user.extraGroups;
      };
    };

    programs.zsh.enable = true;
  };
}
