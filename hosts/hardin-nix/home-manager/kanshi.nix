{
  services.kanshi = {
    enable = true;
    # systemdTarget = "graphical.target"; # "hyprland-session.target";

    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
          }
        ];
      }
      {
        profile.name = "acm_office"; # TODO: update this to support the use of the external HDMI port
        profile.outputs = [
          {
            criteria = "DVI-I-2";
          }
          {
            criteria = "DVI-I-1";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      }
      {
        profile.name = "desk";
        profile.outputs = [
          {
            criteria = "eDP-1";
          }
          {
            criteria = "HDMI-A-1";
          }
        ];
      }
    ];
  };
}
