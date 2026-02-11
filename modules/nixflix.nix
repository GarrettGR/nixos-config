{
  inputs,
  pkgs,
  ...
}: {
  nixflix = {
    enable = true;
    mediaDir = "/data/media";
    stateDir = "/data/.state";
    postgres.enable = true;
    jellyfin = {
      enable = true;
      users.garrettgr = {
        policy.isAdministrator = true;
        password = "3bm3bmchtrJ";
      };
    };
    # sonarr.enable = true;
    # radarr.enable = true;
  };

  environment.systemPackages = with pkgs; [
    qbittorrent
  ];
}
