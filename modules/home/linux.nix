# Linux-only home configuration: the GUI/desktop app set (won't build on darwin)
# plus XDG user dirs and zathura. Guarded so it is inert if ever imported on a
# non-Linux host.
{...}: {
  flake.modules.homeManager.linux = {
    lib,
    pkgs,
    ...
  }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      home.pointerCursor.enable = true;
      home.packages = with pkgs; [
        spotify-player
        psst

        batmon
        keepassxc # look at alternative credential stores (??)

        obsidian

        legcord
        telegram-desktop
        signal-desktop
        # slacky # FIXME: THIS DOENST WORK (says unsupported browser)
        slack-cli

        speedread
        nmap
        speedtest-cli
        rclone
        fastfetch

        jujutsu
      ];

      programs.zathura.enable = true;

      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          setSessionVariables = true;
        };
      };
    };
}
