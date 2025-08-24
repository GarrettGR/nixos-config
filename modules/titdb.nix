{
  inputs,
  pkgs,
  ...
}: {
  services.titdb = {
    enable = true;

    device = "/dev/input/event2"; # NOTE: THIS HAS TO BE SET TO THE PROPER PATH PER MACHINE
    # user = "garrettgr";

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
