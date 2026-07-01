# macOS-only home additions layered on the shared core: Homebrew shell
# integration and platform-aware rebuild aliases.
{...}: {
  flake.modules.homeManager.darwin = {lib, ...}: {
    programs.zsh = {
      shellAliases = {
        update = "darwin-rebuild switch --flake .#hardin-osx";
        upgrade = "nix flake update; darwin-rebuild switch --flake .#hardin-osx";
      };

      initContent = lib.mkAfter ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
  };
}
