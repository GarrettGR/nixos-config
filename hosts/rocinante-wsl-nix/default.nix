{} : {
  networking.hostName = "rocinante-wsl-nix";
  time.timezone = "America/New_York";

  wsl = {
    enable = true;
    defaultUser = "garrettgr";
    startMenuLaunchers = true;
    # usbip.enable = true;
    useWindowsDriver = true;
  };
}