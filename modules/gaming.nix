# STRICT feature: Steam + Sunshine game streaming. Deduplicated from the former
# per-host hosts/{arrakis,hyperion}-nix/packages.nix blocks. Hosts opt in and
# keep only their unique extras (arrakis creative pkgs, hyperion plasma) locally.
{...}: {
  flake.modules.nixos.gaming = {
    lib,
    pkgs,
    ...
  }: {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
      ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [proton-ge-bin];
    };

    services.sunshine = {
      enable = true;
      openFirewall = true;
      capSysAdmin = true;
      autoStart = true;
    };
  };
}
