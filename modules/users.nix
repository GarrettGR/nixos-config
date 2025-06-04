{pkgs, ...}: {
  users = {
    mutableUsers = false;
    users.garrettgr = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$aJmECtPF9vQFrrcKekuiC.$GdBTLC1ly84/cIJik7AMhK2iy2lYHLJxvVe3ywu9wr8";
      shell = pkgs.zsh;
      extraGroups = ["wheel" "networkmanager" "lp"];
    };
  };

  home-manager = {
    users.garrettgr = import ../home/garrettgr;
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  programs.zsh.enable = true;
}
