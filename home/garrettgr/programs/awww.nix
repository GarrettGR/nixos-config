{
  config,
  pkgs,
  lib,
  ...
}: let
  awww = config.services.awww.package;

  transition = {
    type = "random"; # none | simple | fade | left | right | top | bottom | wipe | wave | grow | center | any | outer | random
    fps = 120;
    durationSec = 1;
    bezier = ".54,0,.34,.99";
  };
  resize = "crop";
  filter = "Lanczos3"; # Nearest | Bilinear | CatmullRom | Mitchell | Lanczos3

  rotateInterval = "1h";

  wallpapers = [
    (pkgs.fetchurl {
      url = "https://images.pexels.com/photos/1141853/pexels-photo-1141853.jpeg";
      hash = "sha256-GG7/ySi7clvbN8pZYgwMEKt8Yl6PHeU2cZd697AiYZA=";
    })
    (pkgs.fetchurl {
      url = "https://images.pexels.com/photos/3131634/pexels-photo-3131634.jpeg";
      hash = "sha256-5ZtykbksGGCaVHRGrmVm/IwX77mIPY1+nHEkl+f94R4=";
    })
    (pkgs.fetchurl {
      url = "https://images.pexels.com/photos/18997075/pexels-photo-18997075.jpeg";
      hash = "sha256-fOmAjYzf1o4/jKDhcJRj2nTQo/8NZlGR6X9xunAZm/w=";
    })
    (pkgs.fetchurl {
      url = "https://images.pexels.com/photos/3013995/pexels-photo-3013995.jpeg";
      hash = "sha256-Fxk6B8gDmlV9Zd6GtTJkFk65MxukxcWvFXezpWgg8Lc=";
    })
  ];

  currentLink = "${config.xdg.cacheHome}/awww-current";

  setWallpaper = pkgs.writeShellScript "awww-set-wallpaper" ''
    for _ in $(seq 1 40); do
      ${awww}/bin/awww query >/dev/null 2>&1 && break
      sleep 0.1
    done
    pick=$(${pkgs.coreutils}/bin/shuf -n 1 -e ${lib.escapeShellArgs (map toString wallpapers)})
    ${pkgs.coreutils}/bin/mkdir -p "${config.xdg.cacheHome}"
    ${pkgs.coreutils}/bin/ln -sfn "$pick" "${currentLink}"
    exec ${awww}/bin/awww img "$pick" \
      --transition-type ${transition.type} \
      --transition-fps ${toString transition.fps} \
      --transition-duration ${toString transition.durationSec} \
      --transition-bezier ${transition.bezier} \
      --resize ${resize} \
      --filter ${filter} \
  '';
in {
  services.awww = {
    enable = true;
    extraArgs = [ "--no-cache" ];
  };

  systemd.user.services.awww-wallpaper = {
    Unit = {
      Description = "Apply a random wallpaper via awww";
      Requires = [ "awww.service" ];
      After = [ "awww.service" ];
      PartOf = [ "awww.service" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${setWallpaper}";
    };
    Install.WantedBy = [ "awww.service" ];
  };

  systemd.user.timers.awww-wallpaper = {
    Unit = {
      Description = "Rotate awww wallpaper every ${rotateInterval}";
      PartOf = [ "awww.service" ];
    };
    Timer = {
      OnUnitActiveSec = rotateInterval;
      Unit = "awww-wallpaper.service";
    };
    Install.WantedBy = [ "awww.service" ];
  };
}
