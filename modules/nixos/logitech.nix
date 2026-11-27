{...}: {
  flake.modules.nixos.logitech = {...}: {
    hardware.logitech.wireless.enable = true;

    programs.solaar = {
      enable = true;
      userService.enable = true;
    };
  };
}
