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
        /srv            100.106.173.3(insecure,rw,sync,no_root_squash,no_subtree_check,crossmnt,fsid=0) # hardin-nix
        /srv           	100.81.253.114(insecure,rw,sync,no_root_squash,no_subtree_check,crossmnt,fsid=0) # hardin-osx
        /srv           	100.98.175.99(insecure,rw,sync,no_root_squash,no_subtree_check,crossmnt,fsid=0) # hyperion-nix
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
