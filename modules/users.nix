{ config, lib, pkgs, ... }:

{
  users.users.garrettgr = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
  };
  
  programs.zsh.enable = true;
}
