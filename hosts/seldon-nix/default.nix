{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/desktop.nix
    ../../modules/networking.nix
    ../../modules/filesystems.nix
  ];

  networking.hostName = "seldon-nix";
  
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
    gfxmodeEfi = "2560x1664";
    theme = "${pkgs.kdePackages.breeze-grub}/grub/themes/breeze";
  };
  boot.kernelParams = [ "apple_dcp.show_notch=1" ];
  
  # Asahi-specific configuration
  hardware.asahi = {
    withRust = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    setupAsahiSound = true;
    peripheralFirmwareDirectory = ../../firmware;
  };

  # Swap configuration - defined here rather than hardware-configuration.nix ??
  swapDevices = [ { 
    device = "/var/lib/swapfile";
    size = 16 * 1024;
  } ];

  environment.systemPackages = with pkgs; [
    mesa
    mesa.drivers
  ];

  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  time.timeZone = "America/New_York";
}
