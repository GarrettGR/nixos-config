# Primary-user identity, referenced by feature modules instead of hardcoding
# "garrettgr". Home directory is set per-platform by the host builders
# (/home/<name> on NixOS, /Users/<name> on darwin), not here.
{lib, ...}: {
  options.flake.user = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "garrettgr";
      description = "Primary user account name.";
    };

    extraGroups = lib.mkOption {
      type = with lib.types; listOf str;
      default = ["wheel" "networkmanager" "lp" "media"];
      description = "Extra groups for the primary user on NixOS hosts.";
    };
  };
}
