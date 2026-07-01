# Populated in Phase 4: builds flake.nixosConfigurations from the named modules
# under config.flake.modules.nixos.* (and homeManager.* via home-manager).
#
# During Phases 0–3 the legacy `mkSystem` block in flake.nix still produces
# nixosConfigurations from the untouched modules/ tree, so this file is an
# intentional no-op for now.
{...}: {
}
