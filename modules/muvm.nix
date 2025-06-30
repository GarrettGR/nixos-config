{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      fex = prev.fex.overrideAttrs (oldAttrs: {
        doCheck = false;
        cmakeFlags =
          oldAttrs.cmakeFlags
          ++ [
            (prev.lib.cmakeFeature "JEMALLOC_OVERRIDE_LG_PAGE" "14")
            (prev.lib.cmakeFeature "JEMALLOC_PAGE_SIZE" "16384")
          ];
        # preConfigure = (oldAttrs.preConfigure or "") + ''
        #   sed -i 's/--with-lg-page=12/--with-lg-page=14/g' $(find . -name "*.cmake")
        # '';
      });
    })
    (final: prev: {
      virglrenderer = prev.virglrenderer.overrideAttrs (old: {
        src = final.fetchurl {
          url = "https://gitlab.freedesktop.org/asahi/virglrenderer/-/archive/asahi-20250424/virglrenderer-asahi-20250424.tar.bz2";
          hash = "sha256-9qFOsSv8o6h9nJXtMKksEaFlDP1of/LXsg3LCRL79JM=";
        };
        mesonFlags = old.mesonFlags ++ [(final.lib.mesonOption "drm-renderers" "asahi-experimental")];
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    fex
    muvm

    libsForQt5.qt5.qtwayland
  ];
}
