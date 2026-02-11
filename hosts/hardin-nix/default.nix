{
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./hardware.nix
    ./packages.nix
    ../../modules/desktop.nix
    ../../modules/networking.nix
    ../../modules/packages.nix
    ../../modules/filesystems.nix
  ];

  networking.hostName = "${hostname}";

  boot = {
    kernelPatches = [
      {
        name = "fix-asahi-build";
        patch = pkgs.writeText "fix-asahi-build.diff" ''
          diff --git a/rust/kernel/iio/common/mod.rs b/rust/kernel/iio/common/mod.rs
          index 570644ce0938..b789e9bf44c9 100644
          --- a/rust/kernel/iio/common/mod.rs
          +++ b/rust/kernel/iio/common/mod.rs
          @@ -2,10 +2,5 @@

           //! IIO common modules

          -#[cfg(any(
          -    CONFIG_IIO_AOP_SENSOR_LAS = "y",
          -    CONFIG_IIO_AOP_SENSOR_ALS = "m",
          -    CONFIG_IIO_AOP_SENSOR_LAS = "y",
          -    CONFIG_IIO_AOP_SENSOR_ALS = "m",
          -))]
          +#[cfg(any(CONFIG_IIO_AOP_SENSOR_LAS, CONFIG_IIO_AOP_SENSOR_ALS,))]
           pub mod aop_sensors;
        '';
      }
    ];
    loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      gfxmodeEfi = "2560x1664";
    };
  };

  hardware.asahi.peripheralFirmwareDirectory = /etc/nixos/firmware;

  environment.systemPackages = with pkgs; [
    asahi-bless
    asahi-btsync
    asahi-wifisync
    # asahi-nvram
    # asahi-bless
    mesa
    alsa-utils
    # alsaequal
    lxqt.pavucontrol-qt
  ];

  services = {
    xserver.videoDrivers = ["displaylink" "modesetting"];
    automatic-timezoned.enable = true;
  };
}
