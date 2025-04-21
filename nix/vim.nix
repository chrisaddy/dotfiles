{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    colorschemes.tokyonight.enable = true;
    # extraPlugins = [pkgs.vimPlugins.challenger_deep];
    # colorscheme = "challenger_deep";
    globals.mapleader = " ";
    globals.maplocalleader = " ";
    opts = {
      number = true;
      relativenumber = true;
      mouse = "a";
      showmode = false;
      clipboard = "unnamedplus";
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      list = true;
      listchars = {
        tab = "» ";
        trail = "·";
        nbsp = "␣";
      };
      inccommand = "split";
      cursorline = true;
      scrolloff = 10;
      termguicolors = true;
    };

    plugins.mini.enable = true;
    plugins.oil.enable = true;

    plugins = {
      avante = {
        enable = true;
        autoLoad = true;
      };
      lsp-format.enable = true;
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd = {
            enable = true;
          };
          yamlls = {
            enable = true;
            settings = {
              schemaStore = {
                enable = false;
                url = "";
              };
            };
          };
          rust_analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
          html.enable = true;
          pyright.enable = true;
          dockerls.enable = true;
          markdown_oxide.enable = true;
        };
        # keymaps = {
        #   silent = true;
        #   lspBuf = {
        #     gd = {
        #       action = "definition";
        #       desc = "Goto Definition";
        #     };
        #     gr = {
        #       action = "references";
        #       desc = "Goto References";
        #     };
        #     gD = {
        #       action = "declaration";
        #       desc = "Goto Declaration";
        #     };
        #     gI = {
        #       action = "implementation";
        #       desc = "Goto Implementation";
        #     };
        #     gT = {
        #       action = "type_definition";
        #       desc = "Type Definition";
        #     };
      };
      which-key = {
        enable = true;
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      {
        mode = "n";
        key = "<leader>q";
        action.__raw = "vim.diagnostic.setloclist";
        options.desc = "[q]uickfix list open";
      }
      {
        mode = "n";
        key = "<leader>fs";
        action = "<cmd>w<cr>";
        options.desc = "[f]ile [s]ave";
      }
      {
        mode = "n";
        key = "<leader>o";
        action = "<cmd>Oil<cr>";
        options.desc = "[o]il";
      }
      {
        mode = "n";
        key = "<leader>wj";
        action = "<cmd>split<cr>";
        options.desc = "[w]indow split down";
      }
      {
        mode = "n";
        key = "<leader>wl";
        action = "<cmd>vsplit<cr>";
        options.desc = "[w]indow split right";
      }
    ];

    autoCmd = [
      # {
      #   event = "TextYankPost";
      #   # desc = "Highlight on yank";
      #   group = "highlight-yank";
      #   callback.__raw = "function() vim.highlight.on_yank() end";
      # }
    ];
    plugins.lualine.enable = true;
  };
}
# return {
#   'folke/which-key.nvim',
#   event = 'VimEnter',
#   opts = {
#     delay = 0,
#     },
#
#     spec = {
#       { '<leader>c', group = '[c]ode', mode = { 'n', 'x' } },
#       { '<leader>d', group = '[d]ocument' },
#       { '<leader>r', group = '[r]ename' },
#       { '<leader>s', group = '[s]earch' },
#       { '<leader>w', group = '[w]orkspace' },
#       { '<leader>t', group = '[t]oggle' },
#       { '<leader>tg', group = '[t]ogggle [g]it' },
#       { '<leader>tgd', group = '[t]ogggle [g]it [d]iff' },
#       { '<leader>g', group = '[g]it', mode = { 'n', 'v' } },
#       { '<leader>gh', group = '[g]it [h]unk', mode = { 'n', 'v' } },
#     },
#   },
# }

