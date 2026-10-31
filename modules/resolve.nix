# DaVinci Resolve Studio with the license check byte-patched out of the
# unwrapped binary. The FHS wrapper is kept as-is; replaceDependencies swaps the
# inner `davinci` derivation for the patched one without rebuilding the env.
{...}: {
  flake.modules.nixos.resolve = {pkgs, ...}: let
    nonFhsOriginalDavinci = pkgs.davinci-resolve-studio.passthru.davinci;
    davinciPatched = nonFhsOriginalDavinci.overrideAttrs (
      finalAttrs: prevAttrs: {
        preFixup = ''
          file="$out/bin/resolve"

          patchByte() {
            local pattern="$1" offset="$2" byte="$3"
            local matches
            matches=$(LANG=C grep -obUaP "$pattern" "$file" | cut -d: -f1)
            if [[ -z $matches ]]; then
              echo "pattern not found: $pattern"
              return
            fi
            for patternOffset in $matches; do
              instructionOffset=$(($patternOffset + $offset))
              echo "patching byte '0x$(${pkgs.hexdump}/bin/hexdump -s $instructionOffset -n 1 -e '/1 "%02x"' "$file")' -> '$byte' at offset $instructionOffset"
              echo -en "$byte" | dd conv=notrunc of="$file" bs=1 seek=$instructionOffset count=1 status=none
            done
          }

          patchByte "\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\x74\x11\x48\x8B\x45\xC8\x8B" 9 "\xEB"
          patchByte "\x74\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00" 0 "\xEB"

          patchByte "\x40\x84\xED\x74.\xBF\x16\x00\x00\x00\xBE.\x01\x00\x00\xE8" 3 "\x75"
        '';
      }
    );
    davinciResolvePatched = pkgs.replaceDependencies {
      drv = pkgs.davinci-resolve-studio;
      replacements = [
        {
          oldDependency = nonFhsOriginalDavinci;
          newDependency = davinciPatched;
        }
      ];
    };
  in {
    environment.systemPackages = [davinciResolvePatched];
  };

  flake.modules.homeManager.resolve = {
    home.file.".local/share/DaVinciResolve/license/blackmagic.lic".text = ''
      LICENSE blackmagic davinciresolvestudio 999999 permanent uncounted
      hostid=ANY issuer=CGP customer=CGP issued=28-dec-2023
      akey=0000-0000-0000-0000 _ck=00 sig="00"
    '';
  };
}
