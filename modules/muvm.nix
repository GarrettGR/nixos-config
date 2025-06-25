{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    # inputs.nixos-muvm-fex.overlays.default

    (self: super: {
      virglrenderer = super.virglrenderer.overrideAttrs (old: {
        src = self.fetchurl {
          url = "https://gitlab.freedesktop.org/asahi/virglrenderer/-/archive/asahi-20250424/virglrenderer-asahi-20250424.tar.bz2";
          hash = "sha256-9qFOsSv8o6h9nJXtMKksEaFlDP1of/LXsg3LCRL79JM=";
        };
        mesonFlags = old.mesonFlags ++ [(self.lib.mesonOption "drm-renderers" "asahi-experimental")];
      });
    })

    (self: super: {
      fex = super.fex.overrideAttrs (oldAttrs: {
        doCheck = false;
        # jemalloc = super.jemalloc.override {
        #   jemallocConfigureFlags = ["--with-lg-page=16"];
        # };
        cmakeFlags =
          oldAttrs.cmakeFlags
          ++ [
            (self.lib.cmakeFeature "JEMALLOC_OVERRIDE_LG_PAGE" "14")
          ];
      });
    })
  ];

  programs.fuse = {
    userAllowOther = true;
  };

  environment.systemPackages = with pkgs; [
    fex
    muvm
  ];
}
