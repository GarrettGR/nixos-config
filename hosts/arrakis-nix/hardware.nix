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
      device = "/dev/disk/by-uuid/a033f034-6e90-45ed-8d37-a6952a46946d";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/a033f034-6e90-45ed-8d37-a6952a46946d";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/a033f034-6e90-45ed-8d37-a6952a46946d";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };
    "/var/log" = {
      device = "/dev/disk/by-uuid/a033f034-6e90-45ed-8d37-a6952a46946d";
      fsType = "btrfs";
      options = [ "subvol=@log" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/EE28-BFC5";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  networking.useDHCP = lib.mkDefault true;

  services.xserver.videoDrivers = ["nvidia" "amdgpu"];

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
      package = config.boot.kernelPackages.nvidiaPackages.latest; # nvidiaPackages.dc; # <- datacenter drivers
    };

    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
