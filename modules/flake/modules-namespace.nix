# Dendritic module namespace.
#
# Every feature file registers its configuration under
#   flake.modules.<class>.<name>
# where <class> is one of nixos | darwin | homeManager and <name> is the
# feature. Host builders (flake/hosts-{nixos,darwin}.nix) then assemble a host
# by referencing these named modules instead of file paths.
{lib, ...}: {
  options.flake.modules = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf deferredModule);
    default = {};
    description = "Dendritic feature modules, keyed by class then name.";
  };
}
