{
  inputs,
  pkgs,
  ...
}: {
  nixflix = {
    enable = true;
    # serviceDependencies = [ "tailscale.service" ];
    mediaUsers = ["garrettgr"];
    downloadsDir = "/data/downloads";
    mediaDir = "/data/media";
    stateDir = "/data/.state";
    nginx = {
      enable = true;
      addHostsEntries = true;
    };
    # postgres.enable = true;
    torrentClients.qbittorrent = {
      enable = true;
      serverConfig.Preferences.WebUI = {
        Username = "garrettgr";
      };
    };
    jellyfin = {
      enable = true;
      encoding = {
        allowAv1Encoding = false;
        allowHevcEncoding = true;
        enableAudioVbr = true;
        enableDecodingColorDepth10HevcRext = true;
        enableEnhancedNvdecDecoder = true;
        hardwareAccelerationType = "nvenc";
      };
      network = {
        autoDiscovery = true;
        enableUPnP = true; # insecure ??
        knownProxies = ["127.0.0.1"];
      };
      libraries = {
        Movies = {
          collectionType = "movies";
          enableRealtimeMonitor = true;
          metadataCountryCode = "US";
          paths = [
            "/data/media/movies"
            "/mnt/drive/media/movies"
          ];
          preferredMetadataLanguage = "en";
        };
        Shows = {
          collectionType = "tvshows";
          paths = [
            "/data/media/tv"
            "/data/media/anime"
            "/mnt/drive/media/tv"
            "/mnt/drive/media/anime"
          ];
          seasonZeroDisplayName = "Specials";
        };
      };
      users = {
        garrettgr = {
          mutable = false;
          policy.isAdministrator = true;
        };
        shikhar = {
        };
        corinne = {
        };
      };
    };
    # sonarr.enable = true;
    # radarr.enable = true;
  };

  services.nginx.virtualHosts = let
    jellyfinLocations = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_set_header X-Real-IP $remote_addr;
          proxy_buffering off;
        '';
      };
      locations."/socket" = {
        proxyPass = "http://127.0.0.1:8096";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_set_header X-Real-IP $remote_addr;
        '';
      };
    };
  in {
    "hyperion-nix" =
      jellyfinLocations
      // {
        serverAliases = ["hyperion-nix.halley-census.ts.net"];
      };
    "100.98.175.99" = jellyfinLocations;
    "jellyfin.garrettgr.net" = jellyfinLocations;
  };

  environment.systemPackages = with pkgs; [
    qbittorrent
  ];
}
