{
  config,
  lib,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    ZED_ALLOW_EMULATED_GPU = 1;
    # MESA_VK_DEVICE_SELECT="10005:0"; # NOTE: set mesa to use LLVM-pipe
  };

  programs.zed-editor = {
    enable = true;
    installRemoteServer = true;
    extensions = [
      "nix"
      "toml"
      "dockerfile"
      # "make"
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
      # ui_font_size = 12;
      # buffer_font_size = 14;
    };
    # userKeymaps = { };
  };
}
