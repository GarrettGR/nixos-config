{
  pkgs,
  system,
  inputs,
  lib,
  ...
}: let
  pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  environment.systemPackages = with pkgs; [];

  services.desktopManager.plasma6.enable = true;

  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
    autoStart = true;
    # applications = {};
  };
}
