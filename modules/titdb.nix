{
  inputs,
  pkgs,
  ...
}: {
  services.titdb = {
    enable = true;

    device = "/dev/input/by-path/platform-24eb30000.input-event-mouse";

    mode = "flex";

    margins = {
      left = 50;
      right = 10;
      top = 0;
      bottom = 15;
    };

    # user = "garrettgr";

    # extraArgs = [ "--verbose" ];
  };

  environment.systemPackages = [
    pkgs.libinput
    inputs.titdb.packages.${pkgs.system}.default
  ];
}
