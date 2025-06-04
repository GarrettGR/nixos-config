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
      availableKernelModules = ["xhci_pci" "nvme" "ahci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = ["amdgpu"];
    };
    kernelModules = ["kvm-amd"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/3d1bb2c3-43a5-4f68-8fd6-93e3802bd164";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/06AB-66BA";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  networking.useDHCP = lib.mkDefault true;

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false; # open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta; # nvidiaPackages.dc; # <- datacenter drivers
    };

    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
