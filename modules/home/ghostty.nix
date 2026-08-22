# ghostty is Linux-only in nixpkgs; on darwin it's installed via app/brew, so
# guard this so `core` stays darwin-safe.
{...}: {
  flake.modules.homeManager.ghostty = {
    lib,
    pkgs,
    ...
  }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      programs.ghostty = {
        enable = true;
        enableZshIntegration = true;
        installVimSyntax = true;
        settings = {
          shell-integration = "zsh"; # NOTE: Is this redundant with the option above ??
          window-decoration = "none";
          clipboard-read = "allow";
          clipboard-write = "allow";
          # Opacity is set via stylix.opacity.terminal (modules/nixos/stylix.nix)
          # since stylix's ghostty target would otherwise override this value.
          focus-follows-mouse = true;
          confirm-close-surface = false;
          # linux-cgroup = "always"; # Linux-only; enable behind pkgs.stdenv.hostPlatform.isLinux if re-adding
          # linux-cgroup-hard-fail = false;
        };
      };
    };
}
