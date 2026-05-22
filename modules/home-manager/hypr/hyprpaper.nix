{config, ...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = false;
      splash = false;

      # wallpaper = [{ monitor = ""; path = "..."; fit_mode = "cover"; }];
    };
  };
}
