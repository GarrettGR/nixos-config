{...}: {
  flake.modules.nixos.audiobookshelf = {
    services.audiobookshelf = {
      enable = true;
      host = "127.0.0.1";
      port = 8000;
    };

    users.users.audiobookshelf.extraGroups = ["media"];
    systemd.tmpfiles.rules = [
      "d /data/media/audiobooks 2775 root media -"
      "d /data/media/podcasts 2775 root media -"
    ];

    services.nginx.virtualHosts."audiobooks.garrettgr.net" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8000";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 0;
          proxy_buffering off;
        '';
      };
    };
  };
}
