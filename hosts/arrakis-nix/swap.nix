# Swap and memory-pressure handling for arrakis-nix 
_: {
  # Part of the disko layout (modules/nixos/disko.nix) generates the mount.
  custom.disko.extraSubvolumes."@swap" = {
    mountpoint = "/swap";
    mountOptions = ["noatime"];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 64 * 1024; # MiB
    }
  ];

  boot.zswap = {
    enable = true;
    compressor = "zstd";
    maxPoolPercent = 20;
    shrinkerEnabled = true;
  };

  systemd.oomd.enableUserSlices = true;
}
