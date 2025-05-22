{
  pkgs,
  system,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    delta
    xh
    dust
    dua
    gitui
    zellij
    hyperfine
    ncspot
    # ripgrep-all
    # wiki-tui
    mprocs
    # presenterm
    playerctl
  ];
}
