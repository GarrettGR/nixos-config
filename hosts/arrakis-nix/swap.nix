# Swap and memory-pressure handling for arrakis-nix (64 GB RAM; large
# graph-analytics datasets that can exceed it).
#
#   zswap   : compressed RAM cache in front of the swapfile. Recently swapped
#             pages stay compressed in RAM; the shrinker writes cold pages out
#             to disk. Preferred over zram when a real swap device exists (the
#             boot.zswap module asserts zram is off and a swap device exists).
#   swapfile: /swap/swapfile in its own @swap subvolume. A subvolume holding
#             an active swapfile can't be snapshotted, and keeping it separate
#             keeps it out of @'s snapper snapshots. With `size` set on btrfs,
#             NixOS creates it via `btrfs filesystem mkswapfile` (NOCOW,
#             uncompressed, as btrfs requires).
#   oomd    : kill the offending process in the user session instead of
#             letting the desktop freeze.
#
# TODO: revisit once the NVMe Optane drive is installed (swap partition there,
# with a higher priority than this swapfile).
_: {
  # Part of the disko layout (modules/nixos/disko.nix) -> generates the mount.
  # Existing installs: create it once with
  #   mount -o subvolid=5 /dev/disk/by-partlabel/nixos /mnt
  #   btrfs subvolume create /mnt/@swap && umount /mnt
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
