# Trackpad-input daemon. Self-imports the upstream titdb module so hosts only
# opt into flake.modules.nixos.titdb.
{inputs, ...}: {
  flake.modules.nixos.titdb = {pkgs, ...}: {
    imports = [inputs.titdb.nixosModules.default];

    services.titdb = {
      enable = true;

      device = "/dev/input/event2"; # NOTE: THIS HAS TO BE SET TO THE PROPER PATH PER MACHINE

      mode = "flex";
      margins = {
        left = 15;
        right = 15;
        top = 10;
        bottom = 10;
      };
    };

    environment.systemPackages = [
      pkgs.libinput
      inputs.titdb.packages.${pkgs.stdenv.hostPlatform.system}.default # NOTE: including it as a package is mostly for testing
    ];
  };
}
