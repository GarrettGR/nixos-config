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

    # The login shell is bash and usually can't be changed (no chsh / LDAP-
    # managed), so bash hands interactive sessions to zsh. HM's ~/.bashrc puts
    # initExtra after its interactive guard, so scp/sftp/rsync and batch jobs
    # never see the exec. Set NO_ZSH=1 to stay in bash for a session.
    programs.bash = {
      enable = true;
      # Keep the site config (module system, scheduler env, proxies) that a
      # cluster's default ~/.bashrc would normally source.
      bashrcExtra = ''
        [ -r /etc/bashrc ] && . /etc/bashrc
      '';
      initExtra = ''
        if [ -z "$NO_ZSH" ] && [ -z "$ZSH_VERSION" ] && [ -x "${zsh}" ]; then
          export SHELL="${zsh}"
          exec "${zsh}" -l
        fi
      '';
    };

    # `module load ...` is a shell function, so it doesn't survive the exec;
    # re-initialize Lmod / Environment Modules for zsh when the site has one.
    programs.zsh.initContent = ''
      if [[ -n "$MODULESHOME" && -r "$MODULESHOME/init/zsh" ]]; then
        source "$MODULESHOME/init/zsh"
      fi
    '';
  };
}
