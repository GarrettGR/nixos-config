{config, ...}: let
  top = config;
in {
  flake.modules.nixos.asahi_debug = {
    specialisation.debug.configuration = {
      imports = [top.flake.modules.nixos.monitoring];
      system.nixos.tags = ["debug"];
      boot.kernelParams = ["asahi.debug_flags=0x40000"];
    };

    environment.shellAliases.asahi-debug = builtins.concatStringsSep " " [
      "if [ -e /run/current-system/specialisation/debug ];"
      "then sudo /nix/var/nix/profiles/system/specialisation/debug/bin/switch-to-configuration test && echo 'now on: debug';"
      "else sudo /nix/var/nix/profiles/system/bin/switch-to-configuration test && echo 'now on: default';"
      "fi"
    ];
  };
}
