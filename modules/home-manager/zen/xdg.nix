{ config, ... }:
{
  xdg.mimeApps =
    let
      desktopFile = config.programs.zen-browser.package.meta.desktopFileName;
      mimeTypes = [
        "application/x-extension-shtml"
        "application/x-extension-xhtml"
        "application/x-extension-html"
        "application/x-extension-xht"
        "application/x-extension-htm"
        "x-scheme-handler/unknown"
        "x-scheme-handler/mailto"
        "x-scheme-handler/chrome"
        "x-scheme-handler/about"
        "x-scheme-handler/https"
        "x-scheme-handler/http"
        "application/xhtml+xml"
        "application/json"
        "text/plain"
        "text/html"
      ];
      associations = builtins.listToAttrs (map (name: {
        inherit name;
        value = desktopFile;
      }) mimeTypes);
    in
    {
      enable = true;
      associations.added  = associations;
      defaultApplications = associations;
    };
}
