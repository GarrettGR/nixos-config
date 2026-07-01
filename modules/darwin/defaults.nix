# macOS system defaults (dock, finder, hot corners), carried over from the old
# /mnt/drive/nix-darwin-config system.nix.
{...}: {
  flake.modules.darwin.defaults = {...}: {
    system.defaults = {
      dock = {
        appswitcher-all-displays = true;
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.15;
        orientation = "bottom";
        tilesize = 48;
        launchanim = false;
        minimize-to-application = true;
        show-process-indicators = false;
        show-recents = false;
        showhidden = true;
        static-only = false;
        dashboard-in-overlay = false;
        persistent-apps = [];
        expose-animation-duration = 0.2;
        expose-group-apps = true;
        wvous-bl-corner = 1;
        wvous-br-corner = 4;
        wvous-tl-corner = 1;
        wvous-tr-corner = 12;
        mru-spaces = false;
      };
      finder = {
        _FXShowPosixPathInTitle = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = true;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        QuitMenuItem = false;
        ShowPathbar = true;
        ShowStatusBar = false;
      };
    };
  };
}
