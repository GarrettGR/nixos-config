{ inputs, config, pkgs, lib, stylix, ... }:
let
  containers = import ./containers.nix;
in
{
  imports = [
    inputs.zen-browser.homeModules.twilight
    ./xdg.nix
  ];

  home.sessionVariables.MOZ_LEGACY_PROFILES = "1";

  # stylix.targets.zen-browser.profileNames = [ "garrettgr" ];

  programs.zen-browser = {
    enable = true;
    suppressXdgMigrationWarning = true;
    policies = import ./policies.nix;

    profiles.garrettgr = {
      id = 0;
      isDefault = true;
      
      containers = containers;
      containersForce = true;
      
      spacesForce = true;
      pinsForce = true;

      settings = import ./settings.nix;
      mods = import ./mods.nix;
      search = import ./search.nix { inherit pkgs; };
      spaces = import ./spaces.nix { inherit containers; };
      pins = import ./pins.nix;

      # keyboardShortcutsVersion = 14; # bump when zen.keyboard.shortcuts.version changes
      keyboardShortcuts = import ./shortcuts.nix;
    };
  };
}
