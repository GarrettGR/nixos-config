{ config, lib, pkgs, ... }:

{
  
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
    python314Packages.pip
    python314Packages.black
    python314Packages.pylint
    python314Packages.isort
    
    # Node.js
    # nodejs_20
    
    # Development tools
    ripgrep
    fzf
    jq
    yq
    tldr
    tio
    
    # Build tools
    cmake
    ninja
  ];
  
  # Direnv for per-directory environment variables
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  
  programs.gh = { # Do I need/want the github CLI?
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
    };
  };
}
