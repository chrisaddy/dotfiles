{pkgs, ...}: {
  home.packages = with pkgs; [
    vale
    markdownlint-cli2
    jq
    hadolint
    hlint
    ruff
  ];

  programs.nixvim = {
    enable = true;
    colorschemes.tokyonight.enable = true;
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
    plugins = {
      avante = {
        enable = true;
        autoLoad = true;
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
        ];
      };
      dap.enable = true;
      dap-ui = {
        enable = true;
        settings = {
          icons = {
            expanded = "▾";
            collapsed = "▸";
            current_frame = "*";
          };
          controls = {
            icons = {
              pause = "⏸";
              play = "▶";
              step_into = "⏎";
              step_over = "⏭";
              step_out = "⏮";
              step_back = "b";
              run_last = "▶▶";
              terminate = "⏹";
              disconnect = "⏏";
            };
          };
        };
      };
      lazygit.enable = true;
      lint = {
        enable = true;
        lintersByFt = {
          dockerfile = ["hadolint"];
          haskell = ["hlint"];
          json = ["jq"];
          markdown = [
            "markdownlint"
            "vale"
          ];
          python = ["ruff"];
          rst = ["vale"];
          text = ["vale"];
        };
      };
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
      };
      lsp-format = {
        enable = true;
        autoLoad = true;
        lspServersToEnable = "all";
      };
      lualine.enable = true;
      magma-nvim.enable = true;
      mark-radar.enable = true;
      marks = {
        enable = true;
      };

      # return {
      #   config = function()
      #     local function list_marks()
      #       local marks_list = vim.fn.getmarklist(vim.fn.bufnr())
      #       local results = {}
      #       for _, mark in ipairs(marks_list) do
      #         if mark.mark:match '^[a-zA-Z]$' then
      #           table.insert(results, mark.file .. ':' .. mark.pos[2])
      #         end
      #       end
      #       return results
      #     end
      #
      #     function _G.jump_to_mark()
      #       local line = vim.api.nvim_get_current_line()
      #       local file, lineno = string.match(line, '(.-):(%d+)')
      #       if file and lineno then
      #         vim.cmd('e ' .. file)
      #         vim.cmd(':' .. lineno)
      #         vim.api.nvim_win_close(0, true)
      #       end
      #     end
      #
      #     function _G.delete_mark()
      #       local line = vim.api.nvim_get_current_line()
      #       local file, lineno = string.match(line, '(.-):(%d+)')
      #       if file and lineno then
      #         -- Remove the mark from the buffer
      #         local marks_list = vim.fn.getmarklist(vim.fn.bufnr())
      #         for _, mark in ipairs(marks_list) do
      #           if mark.file == file and mark.pos[2] == tonumber(lineno) then
      #             vim.fn.setpos("'" .. mark.mark, { 0, 0, 0, 0 }) -- Set mark position to invalid to delete
      #             break
      #           end
      #         end
      #         vim.api.nvim_buf_set_lines(0, vim.fn.line '.' - 1, vim.fn.line '.', false, {})
      #       end
      #     end
      #
      #     function _G.open_marks_menu()
      #       local lines = list_marks()
      #       if #lines == 0 then
      #         print 'No bookmarks set.'
      #         return
      #       end
      #
      #       local buf = vim.api.nvim_create_buf(false, true)
      #       local width = math.floor(vim.o.columns * 0.5)
      #       local height = math.floor(vim.o.lines * 0.5)
      #       local opts = {
      #         relative = 'editor',
      #         width = width,
      #         height = height,
      #         row = (vim.o.lines - height) / 2,
      #         col = (vim.o.columns - width) / 2,
      #         style = 'minimal',
      #         border = 'rounded',
      #       }
      #       vim.api.nvim_open_win(buf, true, opts)
      #
      #       vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      #
      #       vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', ':lua jump_to_mark()<CR>', { noremap = true, silent = true })
      #       vim.api.nvim_buf_set_keymap(buf, 'n', 'd', ':lua delete_mark()<CR>', { noremap = true, silent = true })
      #       vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':lua vim.api.nvim_win_close(0, true)<CR>', { noremap = true, silent = true })
      #     end
      #
      #     vim.api.nvim_set_keymap('n', '<leader>bo', ':lua open_marks_menu()<CR>', { noremap = true, silent = true })
      #   end,
      # }
      mini = {
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
      neogit = {
        enable = true;
        settings = {
          commit_editor.kind = "floating";
          commit_select_view.kind = "floating";
        };
      };
      neotest.enable = true;
      obsidian = {
        enable = true;
        autoLoad = true;
        settings = {
          ui.enable = false;
          completion = {
            min_chars = 2;
            nvim_cmp = true;
          };
          disable_frontmatter = true;
          follow_url_func = ''
            function(url)
              vim.fn.jobstart({"open", url})
            end
          '';
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
          picker = {
            name = "telescope.nvim";
          };
          note_id_func = ''
            function(title)
              if title ~= nil then
                return title:lower()
              else
                return 'untitled'
              end
            end
          '';
          note_path = {
            __raw = ''
              function(spec)
                local path = spec.dir / tostring(spec.id)
                return path:with_suffix('.md')
              end
            '';
          };
        };
      };
      octo = {
        enable = true;
      };
      parrot = {
        enable = true;
        settings = {
          cmd_prefix = "Parrot";
          providers = {
            anthropic = {
              api_key.__raw = "os.getenv 'ANTHROPIC_API_KEY'";
            };
            openai = {
              api_key.__raw = "os.getenv 'OPENAI_API_KEY'";
            };
          };
          hooks = {
            Ask.__raw = ''
              function(parrot, params)
                local template = "Please, answer to this question: {{command}}."
                local model_obj = parrot.get_model("command")
                parrot.logger.info("Asking model: " .. model_obj.name)
                parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "🤖 Ask ~ ", template)
              end
            '';
          };
        };
      };
      # precognition.enable = true;
      project-nvim = {
        enable = true;
        enableTelescope = true;
        settings = {
          detection_methods = [
            "lsp"
            "pattern"
          ];
          patterns = [
            ".git"
            "pyproject.toml"
            "package.yaml"
            "Cargo.toml"
          ];
          showHidden = true;
        };
      };
      scope = {
        enable = true;
      };
      snacks = {
        enable = true;
      };
      supermaven.enable = true;
      telescope = {
        enable = true;
        enabledExtensions = [
          "scope"
        ];
      };
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          c
          diff
          html
          json
          lua
          luadoc
          make
          markdown
          markdown_inline
          nix
          regex
          rust
          query
          sql
          terraform
          toml
          vim
          vimdoc
          xml
          yaml
        ];
        settings = {
          auto_install = false;
          ensure_installed = "all";
          highlight.enable = true;
          indent.enable = true;
        };
      };
      treesitter-textobjects = {
        enable = true;
        lspInterop.enable = true;
        move.enable = true;
        select.enable = true;
      };

      trouble.enable = true;
      twilight = {
        enable = true;
        settings = {
          context = 20;
          dimming = {
            alpha = 0.4;
          };
          expand = [
            "function"
            "method"
          ];
          treesitter = true;
        };
      };
      undotree = {
        enable = true;
      };
      web-devicons.enable = true;
      which-key = {
        enable = true;
      };
      wtf.enable = true;
      yazi.enable = true;
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
        key = "<leader>nn";
        action = "<cmd>ObsidianNew<cr>";
        options.desc = "[n]ew [n]ote";
      }
      {
        mode = "n";
        key = "<leader>sn";
        action = "<cmd>ObsidianSearch<cr>";
        options.desc = "[s]earch [n]otes";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Yazi<cr>";
        options.desc = "[f]ile [f]ind";
      }

      #   },
      #   keys = {
      #     { '<leader>lf', '<cmd>ObsidianFollowLink<cr>', desc = '[L]ink [F]ollow' },
      #   },
      # }

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
        key = "<leader>g";
        action = "";
        options.desc = "[g]it";
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>Neogit<cr>";
        options.desc = "[g]it";
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
        key = "<leader>sm";
        action = "<cmd>Telescope marks<cr>";
        options.desc = "[s]earch [m]arks";
      }
      {
        mode = "n";
        key = "<leader>sp";
        action = "<cmd>Telescope projects<cr>";
        options.desc = "[s]earch [p]rojects";
      }

      {
        mode = "n";
        key = "<leader>sr";
        action = "<cmd>Telescope registers<cr>";
        options.desc = "[s]earch [r]egisters";
      }
      {
        mode = "n";
        key = "<leader>st";
        action = "<cmd>Telescope<cr>";
        options.desc = "[s]earch [t]elescope";
      }
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>Twilight<cr>";
        options.desc = "[t]oggle [t]wilight";
      }
      {
        mode = "n";
        key = "<leader>tu";
        action = "<cmd>UndotreeToggle<cr>";
        options.desc = "[t]oggle [u]ndotree";
      }
      {
        mode = "n";
        key = "<leader>fu";
        action = "<cmd>UndotreeFocus<cr>";
        options.desc = "[f]ocus [u]ndotree";
      }
      {
        mode = "n";
        key = "<leader><leader>";
        action = "<cmd>Telescope scope buffers<cr>";
      }
    ];
  };
}
# #
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
#
#
#     -- Change breakpoint icons
#     -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
#     -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
#     -- local breakpoint_icons = vim.g.have_nerd_font
#     --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
#     --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
#     -- for type, icon in pairs(breakpoint_icons) do
#     --   local tp = 'Dap' .. type
#     --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
#     --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
#     -- end
#
# return {
#   'mfussenegger/nvim-dap',
#   dependencies = {
#     'nvim-neotest/nvim-nio',
#     'williamboman/mason.nvim',
#     'jay-babu/mason-nvim-dap.nvim',
#     'leoluz/nvim-dap-go',
#   },
#   keys = {
#     {
#       '<F5>',
#       function()
#         require('dap').continue()
#       end,
#       desc = 'Debug: Start/Continue',
#     },
#     {
#       '<F1>',
#       function()
#         require('dap').step_into()
#       end,
#       desc = 'Debug: Step Into',
#     },
#     {
#       '<F2>',
#       function()
#         require('dap').step_over()
#       end,
#       desc = 'Debug: Step Over',
#     },
#     {
#       '<F3>',
#       function()
#         require('dap').step_out()
#       end,
#       desc = 'Debug: Step Out',
#     },
#     {
#       '<leader>b',
#       function()
#         require('dap').toggle_breakpoint()
#       end,
#       desc = 'Debug: Toggle Breakpoint',
#     },
#     {
#       '<leader>B',
#       function()
#         require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
#       end,
#       desc = 'Debug: Set Breakpoint',
#     },
#     -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
#     {
#       '<F7>',
#       function()
#         require('dapui').toggle()
#       end,
#       desc = 'Debug: See last session result.',
#     },
#   },
#   config = function()
#     local dap = require 'dap'
#     local dapui = require 'dapui'
#
#     require('mason-nvim-dap').setup {
#       -- Makes a best effort to setup the various debuggers with
#       -- reasonable debug configurations
#       automatic_installation = true,
#
#       -- You can provide additional configuration to the handlers,
#       -- see mason-nvim-dap README for more information
#       handlers = {},
#       },
#     }
#
#     dap.listeners.after.event_initialized['dapui_config'] = dapui.open
#     dap.listeners.before.event_terminated['dapui_config'] = dapui.close
#     dap.listeners.before.event_exited['dapui_config'] = dapui.close
#
#     require('dap-go').setup {
#       delve = {
#         -- On Windows delve must be run attached or it crashes.
#         -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
#         detached = vim.fn.has 'win32' == 0,
#       },
#     }
#   end,
# }
#
#

