# sops-nix secrets. Opt-in feature module: a host imports
# flake.modules.nixos.secrets, then references config.sops.secrets.<name>.path.
#
# NOT YET WIRED INTO HOSTS — activation needs your age keys and the real secret
# values. See secrets/README.md for the one-time setup, after which:
#   - hyperion opts into this module and cloudflare-tunnel.nix points its
#     credentialsFile at config.sops.secrets.cloudflared-creds.path
#   - arrakis opts into this module and n8n.nix points N8N_RUNNERS_AUTH_TOKEN_FILE
#     at config.sops.secrets.n8n-runner-token.path
{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos.secrets = {...}: {
    imports = [inputs.sops-nix.nixosModules.sops];

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      # Each host's age identity is derived from its SSH host key.
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

      secrets = {
        cloudflared-creds = {
          # cloudflared reads this at service start; adjust owner to the service
          # user if you run it non-root.
          mode = "0400";
        };
        n8n-runner-token = {
          owner = config.flake.user.name;
          mode = "0400";
        };
      };
    };
  };
}
