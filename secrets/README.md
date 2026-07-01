# Secrets (sops-nix)

The sops-nix wiring lives in `modules/nixos/secrets.nix`
(`flake.modules.nixos.secrets`). It is **not yet imported by any host** because
activation needs your age keys and the real secret values. Follow these steps
once, then wire it in.

## One-time setup

1. **Personal age key** (kept off-repo, e.g. `~/.config/sops/age/keys.txt`):
   ```sh
   nix run nixpkgs#age -- age-keygen -o ~/.config/sops/age/keys.txt
   ```
   Copy the `age1…` public key into `.sops.yaml` as `user_garrettgr`.

2. **Host age keys** (derived from each host's SSH host key), on hyperion and
   arrakis:
   ```sh
   nix run nixpkgs#ssh-to-age -- -i /etc/ssh/ssh_host_ed25519_key.pub
   ```
   Paste each into `.sops.yaml` as `host_hyperion` / `host_arrakis`.

3. **Create the encrypted store** and add the secrets:
   ```sh
   nix run nixpkgs#sops -- secrets/secrets.yaml
   ```
   Add these keys:
   ```yaml
   cloudflared-creds: |
     { ...contents of the cloudflared tunnel credentials JSON... }
   n8n-runner-token: "your-real-shared-secret"
   ```

## Wire it into the hosts

After the above, flip the two plaintext references to sops:

- **hyperion** — add `m.nixos.secrets` to its `nixosModules` in
  `modules/flake/hosts-nixos.nix`; in `modules/nixos/cloudflare-tunnel.nix`
  set `credentialsFile = config.sops.secrets.cloudflared-creds.path;`.
- **arrakis** — add `m.nixos.secrets` to its `nixosModules`; in
  `modules/nixos/n8n.nix` drop the `environment.etc."n8n-runner-token"` line and
  set `N8N_RUNNERS_AUTH_TOKEN_FILE = config.sops.secrets.n8n-runner-token.path;`.

For darwin, `inputs.sops-nix.darwinModules.sops` is available if the Mac ever
needs secrets.
