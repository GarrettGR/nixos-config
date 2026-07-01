{...}: {
  flake.modules.homeManager.dev = {pkgs, ...}: {
    home.packages = with pkgs; [
      # C/C++
      gnumake
      gcc
      libgcc

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

      jetbrains.clion
      jetbrains.rust-rover

      # Build tools
      cmake
      ninja
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
