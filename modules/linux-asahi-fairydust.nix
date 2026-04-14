{
  nixpkgs.overlays = [
    (final: prev: {
      linux-asahi = prev.lib.makeOverridable ({ _kernelPatches ? [] }:
        let
          kernel = (prev.linux-asahi.override { inherit _kernelPatches; }).kernel.overrideAttrs (_old: {
            src = final.fetchFromGitHub {
              owner = "AsahiLinux";
              repo = "linux";
              rev = "fairydust";
              hash = "sha256-G32SzJW1paAUaBCnw5cou20WwpuVR8OZSDRpV58IUJU=";
            };
          });
        in
        prev.lib.recurseIntoAttrs (prev.linuxPackagesFor kernel)
      ) {};
    })
  ];
}
