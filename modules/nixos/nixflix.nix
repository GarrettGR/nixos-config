{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos.nixflix = {
    pkgs,
    lib,
    ...
  }: {
    imports = [inputs.nixflix.nixosModules.default];

    nixflix = {
      enable = true;
      mediaUsers = [config.flake.user.name];
      downloadsDir = "/data/downloads";
      mediaDir = "/data/media";
      stateDir = "/data/.state";

      nginx = {
        enable = true;
        domain = "hyperion-nix";
        addHostsEntries = true;
      };

      postgres.enable = true;

      torrentClients.qbittorrent = {
        enable = true;
        serverConfig.Preferences.WebUI = {
          Username = config.flake.user.name;
        };
      };

      downloadarr.enable = true;

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
          enableUPnP = true;
        };
        users = {
          ${config.flake.user.name} = {
            mutable = false;
            policy.isAdministrator = true;
          };
          shikhar = {};
          corinne = {};
        };

        plugins.AniDB.enable = false; # breaking on `builtins.convertHash` (missing on lix version)
      };

      sonarr = {
        enable = true;
        mediaDirs = [
          "/data/media/tv"
          "/mnt/drive/media/tv"
        ];
      };

      sonarr-anime = {
        enable = true;
        mediaDirs = [
          "/data/media/anime"
          "/mnt/drive/media/anime"
        ];
      };

      radarr = {
        enable = true;
        mediaDirs = [
          "/data/media/movies"
          "/mnt/drive/media/movies"
        ];
      };

      prowlarr = {
        enable = true;
      };

      seerr = {
        enable = true;
        externalUrlScheme = "http";
      };

      recyclarr = {
        enable = true;
        radarrQuality = "1080p";
        sonarrQuality = "1080p";
      };
    };

    services.nginx.virtualHosts."jellyfin.garrettgr.net" = {
      serverAliases = [
        "hyperion-nix"
        "hyperion-nix.halley-census.ts.net"
        "100.98.175.99"
      ];
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

    environment.systemPackages = with pkgs; [qbittorrent];
  };
}
