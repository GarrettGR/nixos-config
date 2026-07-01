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
    };
  };
}
