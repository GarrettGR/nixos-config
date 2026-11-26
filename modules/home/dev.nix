# Terminal dev tooling: toolchains, build tools, CLI helpers, direnv, gh. No
# GUI apps, so it's shared by workstations (via core) and the headless remote
# profiles; IDEs live in dev-gui.
{...}: {
  flake.modules.homeManager.dev = {
    lib,
    pkgs,
    ...
  }: {
    home.packages = with pkgs;
      [
        # C/C++
        gnumake
        gcc

        # Rust
        rustup

        # OCaml
        ocaml
        ocamlPackages.utop

        # Python
        python314

        # Development tools
        claude-code
        ripgrep
        fzf
        serie
        jq
        yq
        tldr
        tio

        # Build tools
        cmake
        ninja
      ]
      # Linux-only toolchain bits (glibc's libgcc); darwin uses its own.
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        libgcc
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
