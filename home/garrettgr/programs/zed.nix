{
  config,
  lib,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    # ZED_ALLOW_EMULATED_GPU = 1;
    # MESA_VK_DEVICE_SELECT="10005:0"; # NOTE: set mesa to use LLVM-pipe
  };

  programs.zed-editor = {
    enable = true;
    installRemoteServer = true;
    extensions = [
      # "nix"
      # "toml"
      "rust"
      # "dockerfile"
      # "make"
      "basher"
      "ocaml"
      "assembly language server"
      # "discord presence"
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
    # userKeymaps = { };
  };
}
