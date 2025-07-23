{lib, ...}: {
  services.hypridle.enable = lib.mkForce false;
}
