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

    plugins.mini = {
      enable = true;
      modules = {
        ai = {
          enable = true;
          n_lines = 50;
          search_method = "cover_or_next";
        };
        bracketed = {
          enable = true;
          buffer = {
            suffix = "b";
          };
          comment = {suffix = "c";};
          conflict = {suffix = "x";};
          diagnostic = {suffix = "d";};
          file = {suffix = "f";};
          indent = {suffix = "i";};
          jump = {suffix = "j";};
          location = {suffix = "l";};
          oldfile = {suffix = "o";};
          quickfix = {suffix = "q";};
          treesitter = {suffix = "t";};
          undo = {suffix = "u";};
          window = {suffix = "w";};
          yank = {suffix = "y";};
        };
        comment = {
          enable = true;
          mappings = {
            comment = "<leader>/";
            comment_line = "<leader>/";
            comment_visual = "<leader>/";
            textobject = "<leader>/";
          };
        };
        completion = {
          enable = true;
          delay = {
            completion = 100;
            info = 100;
            signature = 50;
          };
        };
        diff = {
          enable = true;
          view = {
            style = "sign";
          };
        };
        files = {
          enable = true;
        };
        icons = {
          enable = true;
          style = "glyph";
        };
        map.enable = true;
        notify.enable = true;
        pairs = {
          enable = true;
          modes = {
            insert = true;
            command = false;
            terminal = false;
          };
        };
        starter = {
          enable = true;
          content_hooks = {
            "__unkeyed-1.adding_bullet" = {
              __raw = "require('mini.starter').gen_hook.adding_bullet()";
            };
            "__unkeyed-2.indexing" = {
              __raw = "require('mini.starter').gen_hook.indexing('all', { 'Builtin actions' })";
            };
            "__unkeyed-3.padding" = {
              __raw = "require('mini.starter').gen_hook.aligning('center', 'center')";
            };
          };
          evaluate_single = true;
          header = ''
            ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ██████╗ ██████╗ ██╗ ██████╗ ██████╗
            ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔══██╗██║██╔═████╗██╔══██╗
            ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝██████╔╝██████╔╝██║██║██╔██║██████╔╝
            ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██╔═══╝ ██╔══██╗██║████╔╝██║██╔══██╗
            ██║  ██║   ██║   ██║     ███████╗██║  ██║██║     ██║  ██║██║╚██████╔╝██║  ██║
            ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝
          '';
          items = {
            "__unkeyed-1.buildtin_actions" = {
              __raw = "require('mini.starter').sections.builtin_actions()";
            };
            "__unkeyed-2.recent_files_current_directory" = {
              __raw = "require('mini.starter').sections.recent_files(10, false)";
            };
            "__unkeyed-3.recent_files" = {
              __raw = "require('mini.starter').sections.recent_files(10, true)";
            };
            "__unkeyed-4.sessions" = {
              __raw = "require('mini.starter').sections.sessions(5, true)";
            };
          };
        };
        snippets = {
          enable = true;
          gen_loader.from_file = "~/.config/nvim/snippets/global.json";
        };
        surround = {
          enable = true;
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };
      };
    };

    plugins.web-devicons.enable = true;
    plugins.lualine.enable = true;

    plugins.neotest = {
      enable = true;
    };

    # return {
    #   {
    #     'nvim-neotest/neotest',
    #     dependencies = {
    #       'nvim-lua/plenary.nvim',
    #       'antoinemadec/FixCursorHold.nvim',
    #       'nvim-treesitter/nvim-treesitter',
    #       'nvim-neotest/neotest-python',
    #     },
    #     config = function()
    #       local neotest = require 'neotest'
    #
    #       local function handle_test_results(test_results)
    #         local errors = {}
    #         for position_id, result in pairs(test_results) do
    #           local pos = neotest.positions.get(position_id)
    #           if result.status == 'failed' then
    #             table.insert(errors, {
    #               filename = pos.path,
    #               lnum = pos.range[1] + 1, -- Convert to 1-based line number
    #               text = result.short .. (result.errors and result.errors[1] or ''),
    #               type = 'E',
    #             })
    #           end
    #         end
    #
    #         if #errors > 0 then
    #           vim.fn.setqflist(errors)
    #           vim.cmd 'copen'
    #         else
    #           vim.fn.setqflist {}
    #           vim.cmd 'cclose'
    #         end
    #       end
    #
    #       neotest.setup {
    #         adapters = {
    #           require 'neotest-python' {
    #             runner = 'pytest',
    #             python = vim.fn.exepath 'python3',
    #             args = { '--verbose' },
    #             root_files = { 'pyproject.toml', 'setup.cfg', 'setup.py', 'pytest.ini' },
    #           },
    #         },
    #         output = {
    #           open_on_run = true,
    #           enter = true,
    #         },
    #         status = {
    #           virtual_text = true,
    #           signs = true,
    #         },
    #       }
    #
    #       -- vim.api.nvim_create_autocmd('BufWritePost', {
    #       --   pattern = '*.py',
    #       --   callback = function()
    #       --     neotest.run.run(vim.fn.expand '%', {
    #       --       handler = handle_test_results,
    #       --     })
    #       --   end,
    #       -- })
    #       --
    #       vim.keymap.set('n', '<leader>tf', function()
    #         neotest.run.run(vim.fn.expand '%')
    #       end, { desc = 'Run current file' })
    #
    #       vim.keymap.set('n', '<leader>ts', function()
    #         neotest.summary.toggle()
    #       end, { desc = 'Toggle test summary' })
    #
    #       vim.keymap.set('n', '<leader>to', function()
    #         neotest.output.open { enter = true }
    #       end, { desc = 'Show test output' })
    #     end,
    #     ft = { 'python' },
    #     keys = {
    #       { '<leader>ts', desc = 'Toggle test summary' },
    #       { '<leader>to', desc = 'Show test output' },
    #     },
    #   },
    # }
    #

    plugins.obsidian = {
      enable = true;
      autoLoad = true;
      settings = {
        workspaces = [
          {
            name = "zettelkasten";
            path = "$HOME/vaults/zettelkasten";
            overrides = {
              disable_frontmatter = true;
            };
          }
        ];
        daily_notes = {
          folder = "calendar/daily";
        };
      };
    };

    #     },
    #     completion = {
    #       nvim_cmp = true,
    #       min_chars = 2,
    #     },
    #
    #     note_id_func = function(title)
    #       if title ~= nil then
    #         -- Replace spaces with dashes and remove invalid characters
    #         return title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
    #       else
    #         return 'untitled'
    #       end
    #     end,
    #     note_path_func = function(spec)
    #       -- Use the title as the filename, ensure it has a `.md` suffix
    #       local path = spec.dir / tostring(spec.id)
    #       return path:with_suffix '.md'
    #     end,
    #   },
    #   keys = {
    #     { '<leader>nn', '<cmd>ObsidianNew<cr>', desc = '[N]ote [N]ew' },
    #     { '<leader>ns', '<cmd>ObsidianSearch<cr>', desc = '[N]ote [S]earch' },
    #     { '<leader>lf', '<cmd>ObsidianFollowLink<cr>', desc = '[L]ink [F]ollow' },
    #   },
    # }
    plugins = {
      avante = {
        enable = true;
        autoLoad = true;
      };
      lazygit.enable = true;
      lint.enable = true;
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          basedpyright.enable = true;
          bashls.enable = true;
          dockerls.enable = true;
          docker_compose_language_service.enable = true;
          ghcide.enable = true;
          hls = {
            enable = true;
            installGhc = true;
          };
          html.enable = true;
          htmx.enable = true;
          idris2_lsp.enable = true;
          jqls.enable = true;
          lsp_ai.enable = true;
          markdown_oxide.enable = true;
          nixd.enable = true;
          nushell.enable = true;
          ocamllsp.enable = true;
          postgres_lsp.enable = true;
          ruff.enable = true;
          rust_analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
          sqls.enable = true;
          yamlls = {
            enable = true;
            settings = {
              schemaStore = {
                enable = false;
                url = "";
              };
            };
          };
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
      lsp-format = {
        enable = true;
        autoLoad = true;
        lspServersToEnable = "all";
      };
      telescope.enable = true;
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
      {
        mode = "n";
        key = "<leader>o";
        action = "<cmd>lua MiniFiles.open()<cr>";
        options.desc = "[o]ile file tree";
      }
      {
        mode = "n";
        key = "<leader>mm";
        action = "<cmd>lua MiniMap.toggle()<cr>";
        options.desc = "[m]ini [m]ap";
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<cr>";
        options.desc = "[m]ini [m]ap";
      }
      {
        mode = "n";
        key = "<leader>sc";
        action = "<cmd>Telescope command_history<cr>";
      }
      {
        mode = "n";
        key = "<leader>sf";
        action = "<cmd>Telescope find_files<cr>";
      }
      {
        mode = "n";
        key = "<leader>st";
        action = "<cmd>Telescope registers<cr>";
      }
      {
        mode = "n";
        key = "<leader>st";
        action = "<cmd>Telescope<cr>";
      }
      {
        mode = "n";
        key = "<leader><leader>";
        action = "<cmd>Telescope buffers<cr>";
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
  };
}
