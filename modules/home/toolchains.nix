# Compilers, language runtimes and build tools. Workstation-only (imported by
# core): on clusters we use the site's versions through `module load`, which
# are built for that hardware and interconnect.
{...}: {
  flake.modules.homeManager.toolchains = {
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

        # Build tools
        cmake
        ninja
      ]
      # Linux-only toolchain bits (glibc's libgcc); darwin uses its own.
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        libgcc
      ];
  };
}
