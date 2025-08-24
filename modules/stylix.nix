{
  self,
  pkgs,
  inputs,
  ...
}: {
  stylix = {
    enable = true;

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    polarity = "dark";

    # targets.hyprland.hyprpaper.enable = true;
    # targets.hyprpaper.enable = true;
    image = pkgs.fetchurl {
      url = "https://images.pexels.com/photos/1141853/pexels-photo-1141853.jpeg";
      hash = "sha256-GG7/ySi7clvbN8pZYgwMEKt8Yl6PHeU2cZd697AiYZA=";
    };

    cursor = {
      package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
      name = "BreezX-RosePine-Linux";
      size = 24;
    };

    # fonts = {
    #   monospace = {
    #     package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
    #     name = "JetBrainsMono Nerd Font Mono";
    #   };
    #   sansSerif = {
    #     package = pkgs.dejavu_fonts;
    #     name = "DejaVu Sans";
    #   };
    #   serif = {
    #     package = pkgs.dejavu_fonts;
    #     name = "DejaVu Serif";
    #   };
    # };
  };
}
