# Zen browser. The implementation lives in ./_zen (underscore-prefixed so
# import-tree skips its data files); this registers it as one named module.
{...}: {
  flake.modules.homeManager.zen = import ./_zen;
}
