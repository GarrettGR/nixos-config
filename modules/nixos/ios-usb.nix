{...}: {
  flake.modules.nixos.ios-usb = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      libimobiledevice
      ifuse
      idevicerestore
    ];

    services.usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };

    systemd.tmpfiles.rules = [
      "d /tmp/iphone 0775 - users -"
    ];
  };
}
