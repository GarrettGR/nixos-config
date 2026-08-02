# System theming. Self-imports the upstream stylix module.
{inputs, ...}: {
  flake.modules.nixos.stylix = {pkgs, ...}: {
    imports = [inputs.stylix.nixosModules.stylix];

    stylix = {
      enable = true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      polarity = "dark";

      cursor = {
        package = inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default;
        name = "BreezX-RosePine-Linux";
        size = 24;
      };

      # Stylix's ghostty target sets background-opacity from this option
      # (default 1.0), which otherwise wins over modules/home/ghostty.nix's
      # setting since ghostty config keys are last-write-wins.
      opacity = {
        terminal = 0.85;
        desktop = 0.85; # waybar background
        popups = 0.85; # dunst notifications
        applications = 0.85; # zen-browser chrome/content
      };

      fonts.monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };
  };
}
