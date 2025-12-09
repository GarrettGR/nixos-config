{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["usb_storage"];
      kernelModules = [];
    };
    kernelModules = [];
    kernelParams = ["apple_dcp.show_notch=1"];
    extraModulePackages = [];
    loader.efi.canTouchEfiVariables = false;
  };

  services.fstrim.enable = true;

  services.titdb.device = lib.mkForce "/dev/input/by-path/platform-2a9b30000.input-event-mouse";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/9a367bff-77b8-491a-b653-96bf79b5c542";
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/C833-0A0F";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  # TODO: setup zram/zswap (whichever is recommended by asahi upstream)
  # swapDevices = [
  #   {
  #     device = "/var/lib/swapfile";
  #     size = 16 * 1024;
  #   }
  # ];

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  hardware = {
    graphics.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    asahi.setupAsahiSound = true;
  };
}
