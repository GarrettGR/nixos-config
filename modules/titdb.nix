{
  config,
  lib,
  ...
}: {
  services.titdb = {
    enable = true;

    device = "/dev/input/event2";

    mode = "flex";

    margins = {
      left = 10;
      right = 10;
      top = 0;
      bottom = 15;
    };

    # user = "garrettgr";

    # extraArgs = [ "--verbose" ];
  };

  # environment.systemPackages = [ inputs.titdb.packages.${pkgs.system}.default ];
}
