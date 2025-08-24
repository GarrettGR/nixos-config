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

  boot.initrd.availableKernelModules = ["usb_storage"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  services.fstrim.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c3ba93f4-02bb-45a2-b400-7f9e77759676";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F7C0-190A";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  services.logind.extraConfig = "HandlePowerKey=ignore";

  systemd.services.power-button = {
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      User = "root";
    };
    script = ''
      ${pkgs.evtest}/bin/evtest /dev/input/by-path/platform-macsmc-hid-event |
      ${pkgs.gnugrep}/bin/grep --line-buffered "KEY_POWER.*value 1" |
      while read line; do
        ${pkgs.sudo}/bin/sudo -u garrettgr WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1000 ${pkgs.wlogout}/bin/wlogout &
      done
    '';
  };

  security.sudo.extraRules = [
    {
      groups = ["wheel"];
      commands = [
        {
          command = "${pkgs.systemd}/bin/systemctl poweroff";
          options = ["NOPASSWD"];
        }
        {
          command = "${pkgs.systemd}/bin/systemctl reboot";
          options = ["NOPASSWD"];
        }
        {
          command = "${pkgs.systemd}/bin/systemctl suspend";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.login1.power-off" ||
        action.id == "org.freedesktop.login1.reboot" ||
        action.id == "org.freedesktop.login1.suspend" ||
        action.id == "org.freedesktop.login1.hibernate") {
          if (subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
      }
    });
  '';

  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
