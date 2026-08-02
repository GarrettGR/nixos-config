# hardin-nix host-local home config. The shared home (core, linux, desktop,
# waybar-laptop, zen) is attached by the builder; only the display layout is
# host-specific here.
{...}: {
  imports = [
    ./monitors.nix
    ./kanshi.nix
    ./chromium.nix
  ];
}
