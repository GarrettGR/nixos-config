{
  pkgs,
  lib,
  config,
  ...
}: let
  pythonWithPillow = pkgs.python3.withPackages (ps: [ps.pillow]);
in {
  environment.etc."n8n-runner-token".text = "random_secure_shared_secret";

  services.n8n = {
    enable = true;
    taskRunners = {
      enable = true;
      runners = {
        javascript = {
          enable = true;
          command = lib.getExe' config.services.n8n.package "n8n-task-runner";
          healthCheckPort = 5681;
        };
        python = {
          enable = true;
          command = lib.getExe' config.services.n8n.package "n8n-task-runner-python";
          healthCheckPort = 5682;
          environment = {
            N8N_RUNNERS_STDLIB_ALLOW = "json,pathlib,sys,os";
            N8N_RUNNERS_EXTERNAL_ALLOW = "PIL";
            PYTHONPATH = "${pythonWithPillow}/${pythonWithPillow.sitePackages}";
          };
        };
      };
    };

    openFirewall = true;
    environment = {
      N8N_SECURE_COOKIE = false;
      NODES_EXCLUDE = "[]";
      N8N_RUNNERS_AUTH_TOKEN_FILE = "/etc/n8n-runner-token";
      N8N_RESTRICT_FILE_ACCESS_TO = "";
    };
  };
  systemd.services.n8n.serviceConfig = {
    Users = "garrettgr";
    Group = "users";
    SupplementaryGroups = ["docker"];
    ReadWritePaths = ["/opt/battlesnake"];
  };
  systemd.services.n8n-task-runner.serviceConfig = {
    ReadWritePaths = ["/opt/battlesnake"];
  };
}
