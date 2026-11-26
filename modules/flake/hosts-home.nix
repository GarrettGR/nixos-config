{
  inputs,
  config,
  ...
}: let
  m = config.flake.modules;

  mkHome = {
    system,
    username ? config.flake.user.name,
    homeDirectory ? "/home/${username}",
    extraModules ? [],
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = {inherit inputs;};
      modules =
        [
          m.homeManager.cli
          m.homeManager.dev
          m.homeManager.remote
          {
            home.username = username;
            home.homeDirectory = homeDirectory;
            home.stateVersion = "25.05";
          }
        ]
        ++ extraModules;
    };
in {
  flake.homeConfigurations = {
    wulver = mkHome {
      system = "x86_64-linux";
      username = "grg";
      # No /nix on Wulver: the store lives in ~/.nix and is mounted via
      # nix-user-chroot (unprivileged user namespaces are allowed).
      extraModules = [
        {
          remote.nixUserChroot.enable = true;

          # Carried over from Wulver's stock ~/.bashrc.
          remote.bashInit = ''
            module load null

            # >>> conda initialize >>>
            __conda_setup="$('/apps/easybuild/el9_5.x86_64/software/Miniforge3/24.11.3-0/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
            if [ $? -eq 0 ]; then
                eval "$__conda_setup"
            else
                if [ -f "/apps/easybuild/el9_5.x86_64/software/Miniforge3/24.11.3-0/etc/profile.d/conda.sh" ]; then
                    . "/apps/easybuild/el9_5.x86_64/software/Miniforge3/24.11.3-0/etc/profile.d/conda.sh"
                else
                    export PATH="/apps/easybuild/el9_5.x86_64/software/Miniforge3/24.11.3-0/bin:$PATH"
                fi
            fi
            unset __conda_setup
            # <<< conda initialize <<<
          '';
        }
      ];
    };
    remote-x86_64 = mkHome {system = "x86_64-linux";};
    remote-aarch64 = mkHome {system = "aarch64-linux";};
  };
}
