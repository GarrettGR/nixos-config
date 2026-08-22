{...}: {
  flake.modules.homeManager.zed = {
    lib,
    pkgs,
    ...
  }: let
    exe = lib.getExe';

    codelldb = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
  in {
    programs.zed-editor = {
      enable = true;
      installRemoteServer = true;
      extensions = [
        "basher"
        "ocaml"
        "assembly"
        "fortran"
        "neocmake"
        "nix"
        "autocorrect"
        "dockerfile"
        "make"
        "git-firefly"
      ];

      extraPackages = with pkgs; [
        clang-tools
        rust-analyzer
        pyright
        ruff
        fortls
        asm-lsp
        ocamlPackages.ocaml-lsp
        nixd
        nodejs
      ];

      userSettings = {
        edit_predictions.provider = "zed";
        agent = {
          model_parameters = [];
          # default_model = {
          #   provider = "copilot_chat";
          #   model = "claude-3.7-sonnet-thought";
          # };
          dock = "right";
        };

        telemetry = {
          metrics = false;
        };

        vim_mode = true;
        base_keymap = "VSCode";
        confirm_quit = false;

        tab_size = 2;
        hard_tabs = false;

        auto_update = false;

        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = exe pkgs.nodejs "npm";
        };

        load_direnv = "shell_hook";

        format_on_save = "on";

        terminal = {
          shell = "system";
          working_directory = "current_project_directory";
          detect_venv = {
            on = {
              directories = [".venv" "venv" ".env" "env"];
              activate_script = "default";
            };
          };
        };

        colorize_brackets = true;
        redact_private_values = true;
        tabs.file_icons = true;
        project_panel.dock = "left";
        git_panel.dock = "left";
        collaboration_panel.button = false;
        relative_line_numbers = "wrapped";

        bottom_dock_layout = "contained";
        # ui_font_size = lib.mkForce 12;
        # buffer_font_size = lib.mkForce 14;

        lsp = {
          clangd.binary = {
            path = exe pkgs.clang-tools "clangd";
            arguments = ["--background-index" "--clang-tidy"];
          };
          rust-analyzer = {
            binary.path = exe pkgs.rust-analyzer "rust-analyzer";
            settings.check.command = "clippy";
          };
          pyright = {
            binary = {
              path = exe pkgs.pyright "pyright-langserver";
              arguments = ["--stdio"];
            };
            settings.python.analysis.typeCheckingMode = "basic";
          };
          ruff.binary = {
            path = exe pkgs.ruff "ruff";
            arguments = ["server"];
          };
          fortls.binary.path = exe pkgs.fortls "fortls";
          asm-lsp.binary.path = exe pkgs.asm-lsp "asm-lsp";
          ocamllsp.binary.path = exe pkgs.ocamlPackages.ocaml-lsp "ocamllsp";
          nixd.binary.path = exe pkgs.nixd "nixd";
        };

        languages."Python".formatter.language_server.name = "ruff";

        languages."Nix".language_servers = ["nixd" "!nil"];

        dap.CodeLLDB.binary = codelldb;

        agent_servers."Claude Code".command = exe pkgs.claude-agent-acp "claude-agent-acp";
      };
    };
  };
}
