{hostname, ...}: {
  networking.hostName = "${hostname}";

  wsl = {
    enable = true;
    defaultUser = "garrettgr";
    startMenuLaunchers = true;
    # usbip.enable = true;
    useWindowsDriver = true;
  };
}
