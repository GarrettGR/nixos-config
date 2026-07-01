# Linux-only home configuration: the GUI/desktop app set (won't build on darwin)
# plus XDG user dirs and zathura. Guarded so it is inert if ever imported on a
# non-Linux host.
{...}: {
  flake.modules.homeManager.linux = {
    lib,
    pkgs,
    ...
  }:
    lib.mkIf pkgs.stdenv.isLinux {
      home.packages = with pkgs; [
        spotify-player
        psst

        batmon
        keepassxc # look at alternative credential stores (??)

        obsidian
        # bitwarden-desktop # FIXME: pulls in EOL electron-39.8.10

        legcord
        telegram-desktop
        signal-desktop
        # slacky # FIXME: THIS DOENST WORK (says unsupported browser)
        slack-cli

        speedread
        nmap
        speedtest-cli
        localsend
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
