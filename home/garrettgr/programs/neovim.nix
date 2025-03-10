{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      # Interface
      vim-airline
      vim-airline-themes
      nvim-web-devicons
      
      # Color schemes
      tokyonight-nvim
      nord-nvim
      
      # File navigation
      nvim-tree-lua
      telescope-nvim
      
      # Git integration
      vim-fugitive
      vim-gitgutter
      
      # LSP and completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      
      # Syntax highlighting and language support
      nvim-treesitter.withAllGrammars
      
      # Editing enhancements
      vim-surround
      vim-commentary
      vim-repeat
      vim-sleuth
      
      # Snippets
      luasnip
      cmp_luasnip
    ];
    
    # Extra Neovim configuration
    extraConfig = ''
      " General settings
      set number
      set relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set autoindent
      set smartindent
      set cursorline
      set ignorecase
      set smartcase
      set mouse=a
      
      " Set colorscheme
      colorscheme tokyonight-moon
      
      " Key mappings
      let mapleader = " "
      
      " File explorer
      nnoremap <leader>e :NvimTreeToggle<CR>
      
      " Telescope mappings
      nnoremap <leader>ff <cmd>Telescope find_files<cr>
      nnoremap <leader>fg <cmd>Telescope live_grep<cr>
      nnoremap <leader>fb <cmd>Telescope buffers<cr>
      nnoremap <leader>fh <cmd>Telescope help_tags<cr>
    '';
    
    # Lua configuration
    extraLuaConfig = ''
      -- Configure LSP
      local lspconfig = require('lspconfig')
      
      -- Setup language servers
      lspconfig.rust_analyzer.setup {}
      lspconfig.pyright.setup {}
      lspconfig.tsserver.setup {}
      lspconfig.rnix.setup {}
      
      -- nvim-cmp setup
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
      
      -- Setup nvim-tree
      require('nvim-tree').setup()
      
      -- Setup treesitter
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      }
    '';
  };
}
