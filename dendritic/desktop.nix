# STRICT cross-cutting feature: the Hyprland/Wayland desktop. Carries both its
# NixOS half (compositor, portals-at-system-level, audio, fonts) and its
# home-manager half (hypr config, waybar, wallpaper, notifications) in one file.
# Opted into by graphical Linux hosts; absent on servers and darwin.
{config, ...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    services.xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    programs.uwsm.enable = true;

    environment.sessionVariables.HYPRLAND_CONFIG = "$HOME/.config/hypr/hyprland.conf";

    security.pam.services.hyprlock = {};
    security.pam.services.hyprlock.fprintAuth = false;

    environment.systemPackages = with pkgs; [
      eww
      wl-clipboard
      wtype
      libnotify
      vulkan-tools
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.monaspace
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono
      nerd-fonts.fantasque-sans-mono
      monaspace
    ];

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  flake.modules.homeManager.desktop = {pkgs, ...}: {
    imports = [
      ./home/_hypr
      config.flake.modules.homeManager.waybar
      config.flake.modules.homeManager.awww
    ];

    services.dunst.enable = true;

    xdg = {
      enable = true;
      portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-hyprland];
        config.common.default = "hyprland";
      };
    };
  };
}
