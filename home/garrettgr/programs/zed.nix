{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    installRemoteServer = true;
    extensions = ["nix" "xy-zed"];
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
      # ui_font_size = 12;
      # buffer_font_size = 14;
    };
    # userKeymaps = { };
  };
}
