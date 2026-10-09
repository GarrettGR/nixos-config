let
  datasource = {
    type = "prometheus";
    uid = "prometheus";
  };

  smc = ''chip=~".*macsmc_hwmon"'';

  labeled = metric: ''${metric}{${smc}} * on(chip, sensor) group_left(label) node_hwmon_sensor_label'';
  labeledOne = metric: label: ''${metric}{${smc}} * on(chip, sensor) group_left(label) node_hwmon_sensor_label{label="${label}"}'';

  # M2 Max: cpu0-3 are the efficiency (Blizzard) cores, cpu4-11 performance (Avalanche) -- need to verify (?)
  byCluster = expr: ''label_replace(label_replace(${expr}, "cluster", "Performance", "cpu", ".*"), "cluster", "Efficiency", "cpu", "[0-3]")'';

  battery = ''power_supply="macsmc-battery"'';

  target = expr: legend: {
    inherit datasource expr;
    legendFormat = legend;
  };

  panel = type: title: unit: pos: targets: {
    inherit type title datasource targets;
    gridPos = pos;
    fieldConfig = {
      defaults = {inherit unit;};
      overrides = [];
    };
  };

  stat = title: unit: x: expr:
    panel "stat" title unit {
      inherit x;
      y = 0;
      w = 6;
      h = 4;
    } [(target expr title)];

  timeseries = title: unit: x: y: targets:
    panel "timeseries" title unit {
      inherit x y;
      w = 12;
      h = 9;
    }
    targets;
in {
  uid = "apple-silicon";
  title = "Apple Silicon";
  tags = ["asahi" "hardware"];
  timezone = "browser";
  refresh = "2s";
  time = {
    from = "now-1h";
    to = "now";
  };
  schemaVersion = 39;

  panels = [
    (stat "Total System Power" "watt" 0 (labeledOne "node_hwmon_power_watt" "Total System Power"))
    (stat "Heatpipe Power" "watt" 6 (labeledOne "node_hwmon_power_watt" "Heatpipe Power"))
    (stat "Hottest Sensor" "celsius" 12 "max(node_hwmon_temp_celsius{${smc}})")
    (stat "Battery" "percent" 18 "node_power_supply_capacity{${battery}}")

    (timeseries "Power" "watt" 0 4 [
      (target (labeled "node_hwmon_power_watt") "{{label}}")
    ])
    (timeseries "Temperatures" "celsius" 12 4 [
      (target (labeled "node_hwmon_temp_celsius") "{{label}}")
      (target ''node_hwmon_temp_celsius{chip="nvme_nvme0"}'' "NVMe SSD")
      (target "node_thermal_zone_temp{type=\"macsmc-battery\"}" "Battery Pack")
      (target ''max(node_hwmon_temp_celsius * on(chip) group_left node_hwmon_chip_names{chip_name="tas2764"})'' "Speaker Amps (hottest)")
    ])

    (timeseries "Fans" "rotrpm" 0 13 [
      (target (labeled "node_hwmon_fan_rpm") "{{label}}")
    ])
    (timeseries "CPU Frequency by Cluster" "hertz" 12 13 [
      (target "avg by (cluster) (${byCluster "node_cpu_scaling_frequency_hertz"})" "{{cluster}} (avg)")
      (target "max by (cluster) (${byCluster "node_cpu_scaling_frequency_hertz"})" "{{cluster}} (max)")
    ])

    (timeseries "CPU Usage by Cluster" "percentunit" 0 22 [
      (target ''1 - avg by (cluster) (${byCluster ''rate(node_cpu_seconds_total{mode="idle"}[$__rate_interval])''})'' "{{cluster}}")
    ])
    ((timeseries "Battery" "percent" 12 22 [
        (target "node_power_supply_capacity{${battery}}" "Charge")
        (target "node_power_supply_power_watt{${battery}}" "Battery Power")
      ])
      // {
        fieldConfig = {
          defaults.unit = "percent";
          overrides = [
            {
              matcher = {
                id = "byName";
                options = "Battery Power";
              };
              properties = [
                {
                  id = "unit";
                  value = "watt";
                }
                {
                  id = "custom.axisPlacement";
                  value = "right";
                }
              ];
            }
          ];
        };
      })
  ];
}
