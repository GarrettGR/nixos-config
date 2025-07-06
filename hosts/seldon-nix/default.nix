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
    ../../modules/muvm-overlay.nix
    ../../modules/filesystems.nix
  ];

  networking.hostName = "${hostname}";

  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
    gfxmodeEfi = "2560x1664";
    # theme = "${pkgs.minimal-grub-theme}";
  };
  boot.kernelParams = ["apple_dcp.show_notch=1"];

  boot.binfmt.emulatedSystems = ["x86_64-linux"];
  nix.settings = {
    extra-platforms = ["x86_64-linux"];
    trusted-users = ["garrettgr"];
  };

  hardware.asahi = {
    # withRust = true;
    # useExperimentalGPUDriver = true;
    # experimentalGPUInstallMode = "replace";
    setupAsahiSound = true;
    # peripheralFirmwareDirectory = ../../firmware;
    peripheralFirmwareDirectory = /etc/nixos/firmware;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  environment.systemPackages = with pkgs; [
    asahi-btsync
    asahi-wifisync
    # asahi-nvram
    # asahi-bless
    mesa
    alsa-utils
    # muvm
    erofs-utils
    # fex
    # (pkgs.extend inputs.nixos-muvm-fex.overlays.default).muvm # https://github.com/nrabulinski/nixos-muvm-fex.git
    # alsaequal
    lxqt.pavucontrol-qt
    moonlight-embedded
  ];

  services.mbpfan.enable = false; #NOTE: macbook air has no fan, don't need the fan controller daemon
  services.xserver.videoDrivers = ["displaylink" "modesetting"];

  time.timeZone = "America/New_York";
}
