{...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installVimSyntax = true;
    settings = {
      window-decoration = "none";
      clipboard-read = "allow";
      clipboard-write = "allow";
      background-opacity = 0.85;
      focus-follows-mouse = true;
      confirm-close-surfaces = true;
      linux-cgroup = "always"; # NOTE: THIS NEEDS TO BE CHANGED FOR MACOS & WSL SYSTEMS !!
      linux-cgroup-hard-fail = false;
    };
  };
}
