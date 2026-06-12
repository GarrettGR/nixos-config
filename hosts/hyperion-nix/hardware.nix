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
      availableKernelModules = [ "vmd" "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
  };

  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-uuid/22bd7cb0-1ded-4759-aeea-6f301580a1b8";
      fsType = "ext4";
    };

    "/mnt/drive" = {
      device = "/dev/disk/by-uuid/1838c59d-1c31-4b84-ad85-50d6f9a0e9a3";
      fsType = "btrfs";
      options = [ "nofail" ];
    };

    "/boot" = { 
      device = "/dev/disk/by-uuid/306E-4804";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };


  networking.useDHCP = lib.mkDefault true;

  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false; # open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
