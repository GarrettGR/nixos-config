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
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false; # open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta; # nvidiaPackages.dc; # <- datacenter drivers
    };

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
