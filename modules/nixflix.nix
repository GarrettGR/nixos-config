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
      users = {
        garrettgr = {
          policy.isAdministrator = true;
        };
        shikhar = {
        };
      };
    };
    # sonarr.enable = true;
    # radarr.enable = true;
  };

  environment.systemPackages = with pkgs; [
    qbittorrent
  ];
}
