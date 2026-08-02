{config, ...}: {
  flake.modules.nixos.nix-settings = {
    lib,
    pkgs,
    ...
  }: {
    nix = {
      package = lib.mkDefault pkgs.lix;
      settings = {
        trusted-users = [config.flake.user.name];

        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = true;

        extra-substituters = [
          "https://nixos-apple-silicon.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
  };
}
