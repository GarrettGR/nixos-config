{
  self,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # inputs.juhradial-mx.nixosModules.default
  ];

  # services.juhradial-mx = {
  #   enable = true;
  # };

  hardware.logitech.wireless.enable = true;

  environment.systemPackages = with pkgs; [
    solaar
    # logiops
  ];

  # systemd.user.services.juhradialmx-overlay = {
  #   description = "JuhRadial MX Overlay - Radial menu overlay for Logitech MX Master";
  #   after = ["graphical-session.target" "juhradialmx-daemon.service" "waybar.service"];
  #   wants = ["graphical-session.target"];
  #   partOf = ["graphical-session.target"];
  #   requires = ["juhradialmx-daemon.service"];
  #   wantedBy = ["graphical-session.target"];
  #   unitConfig = {
  #     StartLimitIntervalSec = 60;
  #     StartLimitBurst = 5;
  #   };
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${inputs.juhradial-mx.packages.${pkgs.system}.default}/bin/juhradial-mx";
  #     Restart = "on-abnormal";
  #     RestartSec = "5s";
  #     Environment = [
  #       # Prevent Qt6's XDG portal theme plugin from calling RegisterAppID,
  #       # which fails under systemd user services because the D-Bus connection
  #       # is already associated with the unit name by systemd's D-Bus policy.
  #       "QT_QPA_PLATFORMTHEME=generic"
  #     ];
  #   };
  # };
}
