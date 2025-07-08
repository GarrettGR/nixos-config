{config, ...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      splash = false;

      # NOTE: these are set by stylix
      # preload = ["${config.home.homeDirectory}/.config/hypr/wallpaper.jpg"];
      # wallpaper = ["${config.home.homeDirectory}/.config/hypr/wallpaper.jpg"];
    };
  };
}
