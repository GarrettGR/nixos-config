{...}: {
  flake.modules.nixos.packages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      delta
      xh
      dust
      dua
      gitui
      zellij
      hyperfine
      ncspot
      mprocs
      playerctl
    ];
  };
}
