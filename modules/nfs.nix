{
  config,
  lib,
  pkgs,
  ...
}: {
  systemd.tmpfiles.rules = [
    "d /srv/nfs 0755 root root -"
  ];

  services.nfs.server.enable = true;
  services.nfs.server.createMountPoints = true;
  services.nfs.server.exports = ''
    /nfs 		*.halley-census.ts.net(insecure,rw,sync,no_root_squash,no_subtree_check,crossmnt,fsid=0)
    # /nfs/project 	10.0.0.0/24(insecure,rw,sync,no_root_squash,no_subtree_check)
    # /nfs/scratch	10.0.0.0/24(insecure,rw,sync,no_root_squash,no_subtree_check,nohide)
  '';
  services.nfs.server.statdPort = 4000;
  services.nfs.server.lockdPort = 4001;
  services.nfs.server.mountdPort = 4002;
  services.nfs.server.extraNfsdConfig = ''
    udp=y
    vers3=on
    vers4=on
  '';
}
