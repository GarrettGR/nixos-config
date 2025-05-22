{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules/desktop.nix
    ../../modules/networking.nix
    ../../modules/packages.nix
    # ../../modules/steam.nix
    # ../../modules/filesystems.nix
  ];

  networking.hostName = "seldon-nix";

  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
    gfxmodeEfi = "2560x1664";
    theme = "${pkgs.minimal-grub-theme}"; # FIXME: probably needs a path specified from here...
  };
  boot.kernelParams = ["apple_dcp.show_notch=1"];

  boot.binfmt.emulatedSystems = ["x86_64-linux"];
  nix.settings = {
    extra-platforms = ["x86_64-linux"];
    trusted-users = ["garrettgr"];
  };

  # Asahi-specific configuration
  hardware.asahi = {
    withRust = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    setupAsahiSound = true;
    # peripheralFirmwareDirectory = ../../firmware;
    peripheralFirmwareDirectory = /etc/nixos/firmware;
  };

  # Swap configuration - defined here rather than hardware-configuration.nix ??
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  environment.systemPackages = with pkgs; [
    mesa
    alsa-utils
    muvm
    fex
    # (pkgs.extend inputs.nixos-mmuvm-fex.overlays.default).muvm # https://github.com/nrabulinski/nixos-muvm-fex.git
    # alsaequal
  ];

  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # external DisplayLink adapter (since dp-alt mode for usb-c doesn't work yet)
  services.xserver.videoDrivers = ["displaylink" "modesetting"];

  time.timeZone = "America/New_York";
}
