{
  services.kanshi = {
    enable = true;
    # systemdTarget = "hyprland-session.target";

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
        profile.name = "acm_office";
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
    ];
  };
}
