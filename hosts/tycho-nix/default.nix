{
  flakeUser,
  lib,
  modulesPath,
  ...
}: let
  hyperion = "100.98.175.99"; # just rely on magicDNS instead?

  # Flip once `tailscale up` has been run and SSH over the tailnet is verified
  sshTailscaleOnly = false;

  proxyToHyperion = ''
    reverse_proxy ${hyperion}:80 {
      flush_interval -1
    }
  '';
in {
  imports = [
    # qemu guest profile, metadata-driven root SSH keys, grub on /dev/vda,
    # auto-growing ext4 root, and system.build.digitalOceanImage.
    (modulesPath + "/virtualisation/digital-ocean-image.nix")
  ];

  networking.hostName = "tycho-nix";

  # The image is the whole system; never rebuild from droplet user data.
  virtualisation.digitalOcean.rebuildFromUserData = false;

  # Only 1 GB of RAM; builds happen on the deploying host, but leave headroom.
  zramSwap.enable = true;

  services.containers.enableSingularity = false;

  services.openssh = {
    openFirewall = !sshTailscaleOnly;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.${flakeUser.name}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBZdozaFsI2idWef8e9J+CrITpn9giAkPgc7AR9PrhwY"
  ];

  # Track egress against the droplet's 1 TB/month allowance (`vnstat -m`).
  services.vnstat.enable = true;

  # Public IP + open UDP port lets hyperion (behind symmetric NAT) reach this
  # node directly instead of through a DERP relay.
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "jellyfin.garrettgr.net".extraConfig = proxyToHyperion;
      "audiobooks.garrettgr.net".extraConfig = proxyToHyperion;
      "requests.garrettgr.net".extraConfig = proxyToHyperion;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [443]; # HTTP/3
    interfaces.tailscale0.allowedTCPPorts = lib.mkIf sshTailscaleOnly [22];
  };
}
