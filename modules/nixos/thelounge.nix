{...}: {
  # Persistent web IRC client (bouncer + UI in one). Runs on the always-on
  # server and stays connected to OFTC; accessed from other hosts over the
  # tailnet at http://<host>:9000.
  flake.modules.nixos.thelounge = {
    services.thelounge = {
      enable = true;
      public = false; # private mode: accounts created with `sudo thelounge add <name>`
      port = 9000;
      extraConfig = {
        host = "0.0.0.0"; # reachable via tailscale0 (trusted interface)

        # Prefill the "add network" form with OFTC, where the Asahi Linux
        # channels live (#asahi, #asahi-dev, #asahi-gpu, ...).
        defaults = {
          name = "OFTC";
          host = "irc.oftc.net";
          port = 6697;
          tls = true;
          rejectUnauthorized = true;
          join = "#asahi";
        };
      };
    };
  };
}
