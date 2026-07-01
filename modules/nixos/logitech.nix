{...}: {
  flake.modules.nixos.logitech = {pkgs, ...}: {
    hardware.logitech.wireless.enable = true;

    environment.systemPackages = with pkgs; [
      solaar
    ];
  };
}
