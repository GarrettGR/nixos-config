# Terminal dev helpers: search/JSON tools, claude-code, direnv, gh. No
# compilers (toolchains) or GUI apps (dev-gui), so it's shared by workstations
# (via core) and the headless remote profiles.
{...}: {
  flake.modules.homeManager.dev = {pkgs, ...}: {
    home.packages = with pkgs; [
      claude-code
      ripgrep
      fzf
      serie
      jq
      yq
      tldr
      tio
    ];

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        editor = "nvim";
      };
    };
  };
}
