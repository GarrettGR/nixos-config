# Homebrew-managed apps for macOS (GUI casks + a few CLI brews Nix shouldn't
# manage), carried over from the old /mnt/drive/nix-darwin-config brew.nix.
{...}: {
  flake.modules.darwin.homebrew = {...}: {
    homebrew = {
      enable = true;

      global.autoUpdate = true;

      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "uninstall";
      };

      brews = [
        "sketchybar"
        "ripgrep"
        "bitwarden-cli"
      ];

      taps = [
        "nikitabobko/tap"
        "FelixKratz/formulae"
      ];

      casks = [
        "font-monaspace"
        "font-monaspace-nerd-font"
        "font-jetbrains-mono-nerd-font"
        "font-fantasque-sans-mono-nerd-font"
        "font-fira-code-nerd-font"
        "font-hack-nerd-font"
        "alfred"
        "aerospace"
        "marta"
        "balenaetcher"
        "alacritty"
        "slack"
        "bitwarden"
        "discord"
      ];
    };
  };
}
