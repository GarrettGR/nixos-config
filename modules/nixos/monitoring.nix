{...}: {
  flake.modules.nixos.monitoring = {
    config,
    lib,
    pkgs,
    ...
  }: let
    node = config.services.prometheus.exporters.node;
    grafanaDataDir = config.services.grafana.dataDir;

    nodeExporterFull = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/rfmoz/grafana-dashboards/99a25cc154c21c4fcbae1aa24352bf1b6764d847/prometheus/node-exporter-full.json";
      hash = "sha256-3+opah4hCqZoGXYU03CLVnGKmb53lKHCwBLNUdp+y4k=";
    };

    scrapeInterval = "1s";

    appleSilicon = pkgs.writeText "apple-silicon.json" (builtins.toJSON (import ./_monitoring/apple-silicon-dashboard.nix));
  in {
    services.prometheus.exporters.node = {
      enable = true;
      listenAddress = "127.0.0.1";
    };

    services.prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      retentionTime = "30d";
      extraFlags = ["--storage.tsdb.retention.size=4GB"];
      globalConfig.scrape_interval = scrapeInterval;
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {targets = ["127.0.0.1:${toString node.port}"];}
          ];
        }
      ];
    };

    services.grafana = {
      enable = true;
      declarativePlugins = [pkgs.grafanaPlugins.prometheus];
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3001;
        };
        security.secret_key = "$__file{${grafanaDataDir}/secret_key}";
        dashboards.min_refresh_interval = scrapeInterval;
        analytics.reporting_enabled = false;
      };

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            uid = "prometheus";
            url = "http://127.0.0.1:${toString config.services.prometheus.port}";
            isDefault = true;
            # Lets $__rate_interval shrink to match the scrape interval.
            jsonData.timeInterval = scrapeInterval;
          }
        ];
        dashboards.settings.providers = [
          {
            name = "default";
            options.path = pkgs.linkFarm "grafana-dashboards" {
              "node-exporter-full.json" = nodeExporterFull;
              "apple-silicon.json" = appleSilicon;
            };
          }
        ];
      };
    };

    systemd.services.grafana.serviceConfig.ExecStartPre = [
      (pkgs.writeShellScript "grafana-secret-key" ''
        key=${grafanaDataDir}/secret_key
        if [ ! -s "$key" ]; then
          umask 077
          ${lib.getExe pkgs.openssl} rand -hex 32 > "$key"
        fi
      '')
    ];
  };
}
