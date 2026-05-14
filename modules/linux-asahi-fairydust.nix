{
  nixpkgs.overlays = [
    (final: prev: {
      linux-asahi = prev.lib.makeOverridable ({ _kernelPatches ? [] }:
        let
          kernel = (prev.linux-asahi.override { inherit _kernelPatches; }).kernel.overrideAttrs (_old: {
            src = final.fetchFromGitHub {
              owner = "AsahiLinux";
              repo = "linux";
              rev = "asahi-wip"; # "fairydust";
              hash = "sha256-rfsPnOyHltP9EXrXRorcQuWRvXBJSmCNUlfVNGIaMb8=";
            };
          });
        in
        prev.lib.recurseIntoAttrs (prev.linuxPackagesFor kernel)
      ) {};
    })
  ];
}
