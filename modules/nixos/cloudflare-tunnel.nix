{...}: {
  flake.modules.nixos.cloudflare-tunnel = {...}: {
    services.cloudflared = {
      enable = true;
      tunnels = {
        "3695a6aa-c6cb-4c56-b99a-cb3eb077e9b6" = {
          # NOTE: plaintext path, replaced with a sops secret in Phase 5.
          credentialsFile = "/home/garrettgr/.cloudflared/3695a6aa-c6cb-4c56-b99a-cb3eb077e9b6.json";

          ingress = {
            "jellyfin.garrettgr.net" = "http://localhost:80";
          };
          default = "http_status:404";
        };
      };
    };
  };
}
