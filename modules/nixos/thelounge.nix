{lib, ...}: {
  flake.modules.nixos.thelounge = {
    services.thelounge = {
      enable = true;
      public = false;
      port = 9000;
      extraConfig = {
        host = "0.0.0.0";

        defaults = {
          name = "OFTC";
          host = "irc.oftc.net";
          port = 6697;
          tls = true;
          rejectUnauthorized = true;
          join = lib.concatStringsSep "," [
            "#asahi"
            "#asahi-alt"
            "#asahi-dev"
            "#asahi-gpu"
            "#asahi-re"
          ];
        };
      };
    };
  };
}
