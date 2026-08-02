# hyperion-nix host-local desktop/server bits. Steam + Sunshine now live in the
# shared gaming module. Runs Plasma via SDDM with autologin.
{
  flakeUser,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    xauth
  ];

  services.openssh = lib.mkForce {
    enable = true;
    settings.X11Forwarding = true;
  };

  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "plasma";
      autoLogin = {
        enable = true;
        user = flakeUser.name;
      };
    };
  };
}
