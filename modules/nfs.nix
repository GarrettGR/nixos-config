{
  config,
  lib,
  pkgs,
  ...
}: {
  systemd.tmpfiles.rules = [
    "d /srv/nfs 0755 root root -"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [111 2049 4000 4001 4002 20048];
    allowedUDPPorts = [111 2049 4000 4001 4002 20048];
  };

  services.nfs = {
    server = {
      enable = true;
      createMountPoints = true;
      exports = ''
        /srv            100.106.173.3(insecure,rw,sync,no_root_squash,no_subtree_check,crossmnt,fsid=0)
        /srv           	100.72.156.101(insecure,rw,sync,no_root_squash,no_subtree_check,crossmnt,fsid=0)
        # /srv        	10.0.0.0/24(insecure,rw,sync,no_root_squash,no_subtree_check,nohide)
      '';
      statdPort = 4000;
      lockdPort = 4001;
      mountdPort = 4002;
    };
    settings = {
      nfsd = {
        udp = true;
        vers3 = true;
        vers4 = true;
      };
    };
  };
}
