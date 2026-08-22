# Neovim (nvf). Self-imports the upstream nvf module.
{inputs, ...}: {
  flake.modules.nixos.nvf = {...}: {
    imports = [inputs.nvf.nixosModules.default];

    programs.nvf = {
      enable = true;
      settings = {
        config.vim = {
          viAlias = false;
          vimAlias = true;

          debugMode = {
            enable = false;
            level = 16;
            logFile = "/tmp/nvim.log";
          };

          spellcheck = {
            enable = true;
          };

          lsp = {
            enable = true;
            formatOnSave = true;
            lspkind.enable = false;
            lightbulb.enable = true;
            lspsaga.enable = false;
            trouble.enable = true;
            lspSignature.enable = true;
            otter-nvim.enable = true;
            nvim-docs-view.enable = true;
          };

          debugger = {
            nvim-dap = {
              enable = true;
              ui.enable = true;
            };
          };

          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;

            nix.enable = true;
            markdown.enable = true;

            bash.enable = true;
            clang.enable = true;
            html.enable = true;
            sql.enable = true;
            java.enable = true;
            go.enable = true;
            lua.enable = true;
            zig.enable = true;
            python.enable = true;
            rust = {
              enable = true;
              extensions.crates-nvim.enable = true;
            };
            assembly.enable = true;
            ocaml.enable = true;
          };

          visuals = {
            nvim-scrollbar.enable = true;
            nvim-web-devicons.enable = true;
            nvim-cursorline.enable = true;
            cinnamon-nvim.enable = true;
            fidget-nvim.enable = true;

            highlight-undo.enable = true;
            indent-blankline.enable = true;

            cellular-automaton.enable = false;
          };

          statusline = {
            lualine = {
              enable = true;
            };
          };

          autopairs.nvim-autopairs.enable = true;

          autocomplete.nvim-cmp.enable = true;
          snippets.luasnip.enable = true;

          filetree = {
            neo-tree = {
              enable = true;
            };
          };

          tabline = {
            nvimBufferline.enable = true;
          };

          binds = {
            whichKey.enable = true;
            cheatsheet.enable = true;
          };

          telescope.enable = true;

          git = {
            enable = true;
            gitsigns.enable = true;
            gitsigns.codeActions.enable = false; # throws an annoying debug message
          };

          minimap.minimap-vim.enable = false;

          dashboard = {
            dashboard-nvim.enable = false;
            alpha.enable = true;
          };

          notify = {
            nvim-notify.enable = true;
          };

          projects = {
            project-nvim.enable = true;
          };

          utility = {
            ccc.enable = false;
            vim-wakatime.enable = false;
            diffview-nvim.enable = true;
            yanky-nvim.enable = false;
            icon-picker.enable = true;
            surround.enable = true;
            leetcode-nvim.enable = true;
            multicursors.enable = true;

            motion = {
              hop.enable = true;
              leap.enable = true;
              precognition.enable = true;
            };
            images = {
              image-nvim.enable = false;
            };
          };

          notes = {
            # obsidian.enable = true; # FIXME: neovim fails to build if obsidian is enabled
            neorg.enable = false;
            orgmode.enable = false;
            todo-comments.enable = true;
          };

          terminal = {
            toggleterm = {
              enable = true;
              lazygit.enable = true;
            };
          };

          ui = {
            borders.enable = true;
            noice.enable = true;
            colorizer.enable = true;
            modes-nvim.enable = false; # the theme looks terrible with catppuccin
            illuminate.enable = true;
            breadcrumbs = {
              enable = true;
              navbuddy.enable = true;
            };
            smartcolumn = {
              enable = true;
              setupOpts.custom_colorcolumn = {
                nix = "110";
                ruby = "120";
                java = "130";
                go = ["90" "130"];
              };
            };
            fastaction.enable = true;
          };

          assistant = {
            chatgpt.enable = false;
            copilot = {
              enable = false;
              cmp.enable = true;
            };
            codecompanion-nvim.enable = false;
          };

          session = {
            nvim-session-manager.enable = false;
          };

          gestures = {
            gesture-nvim.enable = false;
          };

          comments = {
            comment-nvim.enable = true;
          };

          presence = {
            neocord.enable = true;
          };

          options = {
            tabstop = 2;
            shiftwidth = 2;
          };
        };
      };
    };
  };
}
