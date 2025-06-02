{ pkgs,...}: {
  users.users.garrettgr = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "networkmanager" "lp"];
  };

  home-manager.users.garrettgr = import ../home/garrettgr;

  programs.zsh.enable = true;
}
