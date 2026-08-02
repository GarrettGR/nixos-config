{...}: {
  flake.modules.nixos.filesystems = {...}: {
    boot.supportedFilesystems = ["nfs" "ntfs"];
    services.rpcbind.enable = true;

    fileSystems = {
      "/mnt/nfs" = {
        device = "100.102.164.18:/nfs";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "noauto"
          "sync"
          "rsize=1048576"
          "wsize=1048576"
          "nfsvers=4.2"
        ];
      };
    };
  };
}
