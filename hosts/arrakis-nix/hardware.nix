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
      availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    };
    kernelModules = [ "kvm-amd" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/b86b6661-7f8b-419a-94ba-d49f990041fd";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/A0EF-1C05";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  networking.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}