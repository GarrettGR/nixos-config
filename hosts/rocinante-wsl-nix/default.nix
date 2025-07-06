{hostname, ...}: {
  networking.hostName = "${hostname}";
  time.timeZone = "America/New_York";

  wsl = {
    enable = true;
    defaultUser = "garrettgr";
    startMenuLaunchers = true;
    # usbip.enable = true;
    useWindowsDriver = true;
  };
}
