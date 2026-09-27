{...}: {
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecoder,AcceleratedVideoDecodeLinuxZeroCopyGL,PlatformHEVCDecoderSupport"
      "--ignore-gpu-blocklist"
    ];
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
    ];
  };
}
