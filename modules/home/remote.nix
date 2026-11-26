{...}: {
  flake.modules.homeManager.remote = {
    config,
    pkgs,
    ...
  }: let
    zsh = "${config.home.profileDirectory}/bin/zsh";
  in {
    targets.genericLinux.enable = true;
    targets.genericLinux.gpu.enable = false;

    i18n.glibcLocales = pkgs.glibcLocales.override {
      allLocales = false;
      locales = ["en_US.UTF-8/UTF-8"];
    };

    # Keep yazi's cheap previewers but drop the media ones (imagemagick, ffmpeg,
    # poppler, resvg: ~400 MiB incl. X11 libs). Scoped to these profiles only.
    nixpkgs.overlays = [
      (_: prev: {
        yazi = prev.yazi.override {
          optionalDeps = with prev; [jq _7zz fd ripgrep fzf zoxide];
        };
      })
    ];

    # No nix profile.d script is guaranteed to be sourced on a cluster login.
    home.sessionPath = ["${config.home.profileDirectory}/bin"];

    # Terminfo for the terminal we actually connect from, so TERM=xterm-ghostty
    # works over ssh without copying terminfo by hand.
    home.packages = [pkgs.ghostty.terminfo];
  };
}
