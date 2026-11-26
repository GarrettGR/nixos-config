{...}: {
  flake.modules.homeManager.remote = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.remote;
    zsh = "${config.home.profileDirectory}/bin/zsh";
    marker = "# managed by home-manager (homeManager.remote)";

    # Without /nix, the store only exists inside the user namespace, so enter
    # it first and start zsh in there. Never lock out the login: probe the
    # namespace before exec'ing into it (userns may be off on some nodes), and
    # fall back to an interactive bash inside it if zsh isn't in the store.
    handoff =
      if cfg.nixUserChroot.enable
      then ''
        if [[ $- == *i* && -z "$HM_ZSH_HANDOFF" && -z "$NO_ZSH" \
              && -x "${cfg.nixUserChroot.binary}" && -d "${cfg.nixUserChroot.storeDir}" ]] \
           && "${cfg.nixUserChroot.binary}" "${cfg.nixUserChroot.storeDir}" /usr/bin/env true 2>/dev/null; then
          export HM_ZSH_HANDOFF=1 SHELL="${zsh}"
          exec "${cfg.nixUserChroot.binary}" "${cfg.nixUserChroot.storeDir}" /usr/bin/env bash -c '
            [ -x "$0" ] && exec "$0" -l
            echo "nix-user-chroot: $0 missing, staying in bash" >&2
            exec bash -i' "${zsh}"
        fi
      ''
      else ''
        if [[ $- == *i* && -z "$HM_ZSH_HANDOFF" && -z "$NO_ZSH" && -x "${zsh}" ]]; then
          export HM_ZSH_HANDOFF=1 SHELL="${zsh}"
          exec "${zsh}" -l
        fi
      '';

    bashrc = pkgs.writeText "remote-bashrc" ''
      ${marker}
      # Keep the site config (module system, scheduler env, proxies) that a
      # cluster's default ~/.bashrc would normally source.
      [ -r /etc/bashrc ] && . /etc/bashrc

      # The stock RHEL skeleton's user bin dirs (nix-user-chroot lives here).
      if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
        PATH="$HOME/.local/bin:$HOME/bin:$PATH"
      fi
      export PATH

      ${cfg.bashInit}

      ${handoff}
    '';

    bashProfile = pkgs.writeText "remote-bash-profile" ''
      ${marker}
      [ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
    '';
  in {
    options.remote.bashInit = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Site-specific bash setup (module loads, conda init, ...) that runs in
        ~/.bashrc before the hand-off to zsh. Exported environment carries
        over into zsh; shell functions don't (see programs.zsh.initContent).
      '';
    };

    options.remote.nixUserChroot = {
      enable = lib.mkEnableOption ''
        entering a nix-user-chroot namespace at login, for hosts with no /nix
        where the store is bind-mounted from a user directory'';
      storeDir = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/.nix";
        description = "Directory mounted at /nix inside the namespace.";
      };
      binary = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/.local/bin/nix-user-chroot";
        description = "nix-user-chroot binary; lives outside the store so it runs before /nix exists.";
      };
    };

    config = {
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

      # The login shell is bash and can't always be changed (no chsh, or LDAP-
      # managed), so bash hands interactive sessions to zsh. These files are
      # written as real files, not store symlinks, so login works even when
      # /nix/store isn't visible (nix-user-chroot) or the store is broken. The
      # $- guard keeps scp/sftp/rsync and batch jobs in plain bash, and
      # HM_ZSH_HANDOFF stops a nested `bash` from bouncing back into zsh.
      # Set NO_ZSH=1 to stay in bash for a session.
      home.activation.remoteBashDotfiles = lib.hm.dag.entryAfter ["linkGeneration"] ''
        install_dotfile() {
          local src="$1" dest="$2"
          # Keep whatever the site/installer put there the first time we take over.
          if [[ -e "$dest" || -L "$dest" ]] && ! grep -qsF '${marker}' "$dest" \
            && [[ ! -e "$dest.hm-backup" ]]; then
            run mv $VERBOSE_ARG "$dest" "$dest.hm-backup"
          fi
          run rm -f "$dest"
          run install -m 0644 "$src" "$dest"
        }
        install_dotfile ${bashrc} "$HOME/.bashrc"
        install_dotfile ${bashProfile} "$HOME/.bash_profile"
      '';

      # `module` and `conda` are shell functions, so they don't survive the
      # exec from bash (their exported env does: loaded modules, conda base on
      # PATH). Re-create them for zsh from the site's own installs, if present.
      programs.zsh.initContent = ''
        if [[ -n "$MODULESHOME" && -r "$MODULESHOME/init/zsh" ]]; then
          source "$MODULESHOME/init/zsh"
        fi
        if [[ -n "$CONDA_EXE" && -x "$CONDA_EXE" ]]; then
          eval "$("$CONDA_EXE" shell.zsh hook 2>/dev/null)"
        fi
      '';
    };
  };
}
