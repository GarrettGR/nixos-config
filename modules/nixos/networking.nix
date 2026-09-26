{...}: {
  flake.modules.nixos.networking = {pkgs, ...}: {
    networking = {
      nameservers = ["1.1.1.1" "9.9.9.9"];
      networkmanager = {
        enable = true;
        wifi = {
          backend = "wpa_supplicant";
          powersave = true;
        };

        plugins = [pkgs.networkmanager-openconnect];

        ensureProfiles.profiles.njit-vpn = {
          connection = {
            id = "NJIT";
            type = "vpn";
            autoconnect = false;
          };
          vpn = {
            service-type = "org.freedesktop.NetworkManager.openconnect";
            gateway = "vpn.njit.edu";
            protocol = "anyconnect";
            useragent = "AnyConnect-compatible OpenConnect VPN Agent (NetworkManager)";

            gateway-flags = "2";
            cookie-flags = "2";
            gwcert-flags = "2";
            resolve-flags = "2";
            xmlconfig-flags = "2";
            lasthost-flags = "2";
            autoconnect-flags = "0";
            certsigs-flags = "0";
          };
          ipv4.method = "auto";
          ipv6.method = "auto";
        };
      };
    };

    services.tailscale.enable = true;

    environment.systemPackages = with pkgs; [
      openconnect
    ];

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
  };
}
