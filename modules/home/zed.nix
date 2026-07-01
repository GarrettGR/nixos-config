{...}: {
  flake.modules.homeManager.zed = {
    lib,
    pkgs,
    ...
  }: {
    programs.zed-editor = {
      enable = true;
      installRemoteServer = true;
      extensions = [
        "rust"
        "basher"
        "ocaml"
        "assembly language server"
        "autocorrect"
        "neocmake"
      ];
      extraPackages = with pkgs; [
        nixd
      ];
      userSettings = {
        features = {
          copilot = true;
          edit_prediction_provider = "zed";
        };
        agent = {
          model_parameters = [];
          default_model = {
            provider = "copilot_chat";
            model = "claude-3.7-sonnet-thought";
          };
          version = 2;
        };
        telemetry = {
          metrics = false;
        };
        vim_mode = true;
        base_keymap = "VSCode";
        confirm_quit = false;

        bottom_dock_layout = "contained";
        ui_font_size = lib.mkForce 12;
        buffer_font_size = lib.mkForce 14;
      };
    };
  };
}
