{ pkgs, ... }: {
  networking.nameservers = ["1.1.1.1" "9.9.9.9"];

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.wifi.powersave = true;

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  services.tailscale.enable = true;

  # nixpkgs.overlays = [
  #   (import "${builtins.fetchTarball https://github.com/vlaci/openconnect-sso/archive/master.tar.gz}/overlay.nix")
  # ];

  environment.systemPackages = with pkgs; [
    openconnect
    # openconnect-sso
    networkmanager-openconnect
  ];

  networking.openconnect = {
    interfaces = {
      njit = {
        gateway = "vpn.njit.edu";
        user = "grg";
        protocol = "anyconnect";
        autoStart = false;
        # certificate
        # privateKey
        # passwordFile
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22]; # SSH
    allowedUDPPorts = [41641]; # Tailscale

    trustedInterfaces = ["tailscale0"];

    allowedTCPPortRanges = [
      {
        from = 1024;
        to = 65535;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1024;
        to = 65535;
      }
    ];
  };
}
