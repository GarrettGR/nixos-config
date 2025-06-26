{
  inputs,
  pkgs,
  ...
}: {
  services.titdb = {
    enable = true;

    device = "/dev/input/by-path/platform-24eb30000.input-event-mouse";
    # # user = "garrettgr";

    mode = "flex";
    margins = {
      left = 15;
      right = 15;
      top = 10;
      bottom = 10;
    };

    # extraArgs = [ "--verbose" ];
  };

  environment.systemPackages = [
    pkgs.libinput
    inputs.titdb.packages.${pkgs.system}.default # NOTE: including it as a package is mostly for testing
  ];
}
