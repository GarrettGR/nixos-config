# Graphical dev tools (IDEs). Workstation-only: imported by core, never by the
# headless remote profiles. Terminal tooling lives in dev.
{...}: {
  flake.modules.homeManager.dev-gui = {pkgs, ...}: {
    home.packages = with pkgs; [
      jetbrains.clion
      jetbrains.rust-rover
      jetbrains.rider
    ];
  };
}
