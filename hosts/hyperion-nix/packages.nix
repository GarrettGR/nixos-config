{
  pkgs,
  system,
  inputs,
  lib,
  ...
}: let
  pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  environment.systemPackages = with pkgs; [
    xauth
  ];

  services.openssh = lib.mkForce {
    enable = true;
    settings.X11Forwarding = true;
  };

  programs.waybar.enable = lib.mkForce false;
  services = {
    hypridle.enable = lib.mkForce false;
    # hyprpaper.enable = lib.mkForce false;
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "plasma";
      autoLogin = {
        enable = true;
        user = "garrettgr";
      };
    };
  };

  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
    autoStart = true;
    # applications = {};
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };
}
