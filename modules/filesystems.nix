{ config, lib, pkgs, ... }:

{
  
  services.rpcbind.enable = true;
  
  fileSystems = {
    "/mnt/project" = {
      device = "100.85.177.55:/project";
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
    "/mnt/scratch" = {
      device = "100.85.177.55:/scratch";
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
}
