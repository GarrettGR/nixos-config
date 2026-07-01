{...}: {
  flake.modules.homeManager.git = {...}: {
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.name = "Garrett Gonzalez-Rivas";
        user.email = "grg@njit.edu";

        push.autoSetupRemote = true;
        init.defaultBranch = "main";
        pull.rebase = true;
        rebase.autoStash = true;
      };
    };
  };
}
