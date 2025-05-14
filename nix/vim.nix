{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    vale
    markdownlint-cli
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

    extraPlugins = [
      pkgs.vimPlugins.haskell-tools-nvim
      pkgs.vimPlugins.FixCursorHold-nvim
      pkgs.vimPlugins.neotest-plenary
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.nvim-nio
      pkgs.vimPlugins.neotest-haskell
      pkgs.vimPlugins.limelight-vim
    ];
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
      aerial = {
        enable = true;
        settings = {
          attach_mode = "global";
          backends = [
            "treesitter"
            "lsp"
            "markdown"
            "man"
          ];
          disable_max_lines = 5000;
          highlight_on_hover = true;
          ignore = {
            filetypes = [
              "gomod"
            ];
          };
          layout.default_direction = "left";
        };
      };
      barbar = {
        enable = true;
        settings = {
          hide = {
            inactive = true;
            current = true;
          };
        };
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
      cmp-latex-symbols.enable = true;
      cmp-nvim-lsp.enable = true;
      codecompanion.enable = true;
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            bash = [
              "shellcheck"
              "shellharden"
              "shfmt"
            ];
            cpp = ["clang_format"];
            haskell = ["hlint"];
            javascript = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            nix = [
              "alejandra"
              "nixpkgs-fmt"
            ];
            python = ["ruff"];
            "_" = [
              "squeeze_blanks"
              "trim_whitespace"
              "trim_newlines"
            ];
          };
          notify_on_error = true;
          notify_no_formatters = true;
          formatters = {
            shellcheck = {
              command = lib.getExe pkgs.shellcheck;
            };
            shfmt = {
              command = lib.getExe pkgs.shfmt;
            };
            shellharden = {
              command = lib.getExe pkgs.shellharden;
            };
            squeeze_blanks = {
              command = lib.getExe' pkgs.coreutils "cat";
            };
          };
          format_on_save =
            # Lua
            ''
              function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                  return
                end

                return { timeout_ms = 200, lsp_fallback = true }, on_format
               end
            '';
          default_format_opts.lsp_format = "fallback";
        };
      };
      dap = {
        enable = true;
        settings = {
          adapters.ghc = {
            type = "executable";
            command = "haskell-debug-adapter";
            args = [];
          };

          configurations.haskell = [
            {
              type = "ghc";
              request = "launch";
              name = "Debug Haskell";
              workspace = "\${workspaceFolder}";
              startup = "\${file}";
              stopOnEntry = true;
              logFile = "/tmp/haskell-dap.log";
              logLevel = "DEBUG";
              ghciEnv = {};
              ghciPrompt = "λ: ";
              ghciInitialPrompt = "λ: ";
              ghciCmd = "cabal repl";
            }
          ];
          configurations.python = [
            {
              type = "python";
              request = "launch";
              name = "Debug Python";
              program = "${pkgs.python3.interpreter}";
              console = "integratedTerminal";
              justMyCode = false;
            }
          ];
        };
      };
      dap-python = {
        enable = true;
        settings = {
          python_path = "${pkgs.python311}/bin/python";
        };
      };
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
      femaco = {enable = true;};
      fzf-lua = {
        enable = true;
        settings = {
          files = {
            color_icons = true;
            file_icons = true;
            find_opts = {
              __raw = "[[-type f -not -path '*.git/objects*' -not -path '*.env*']]";
            };
            multiprocess = true;
            prompt = "Files❯ ";
          };
          winopts = {
            col = 0.3;
            height = 0.9;
            row = 0.99;
            width = 0.93;
          };
        };
        keymaps = {
          "<leader><leader>" = {
            action = "buffers";
            options = {
              silent = true;
              desc = "[f]ind [b]uffers";
            };
          };
          "<leader>fc" = {
            action = "command_history";
            options = {
              silent = true;
              desc = "[f]ind [c]ommand history";
            };
          };
          "<leader>ff" = {
            action = "files";
            options = {
              silent = true;
              desc = "[f]ind [f]iles";
            };
          };
          "<leader>fg" = {
            action = "live_grep";
            settings = {
              previewers.cat.cmd = lib.getExe' pkgs.coreutils "cat";
            };
            options = {
              silent = true;
              desc = "[f]ind with [g]rep";
            };
          };
          "<leader>fm" = {
            action = "marks";
            options = {
              silent = true;
              desc = "[f]ind [m]arks";
            };
          };
          "<leader>fk" = {
            action = "keymaps";
            options = {
              silent = true;
              desc = "[f]ind [k]eymaps";
            };
          };
          "<leader>fr" = {
            action = "registers";
            options = {
              silent = true;
              desc = "[f]ind [r]egisters";
            };
          };
          "<leader>gc" = {
            action = "git_commit";
            options = {
              silent = true;
              desc = "[g]it [c]ommit";
            };
          };
        };
      };
      gitmessenger = {
        enable = true;
        settings = {
          extra_blame_args = "-w";
          include_diff = "current";
        };
      };
      glance = {
        enable = true;
        settings = {
          border = {
            enable = true;
          };
          height = 40;
          use_trouble_qf = true;
          zindex = 50;
        };
      };
      goyo = {
        enable = true;
      };
      hlchunk = {
        enable = true;
        settings = {
          blank = {
            enable = false;
          };
          chunk = {
            chars = {
              horizontal_line = "─";
              left_bottom = "╰";
              left_top = "╭";
              right_arrow = "─";
              vertical_line = "│";
            };
            enable = true;
            exclude_filetypes = {
              lazyterm = true;
              neo-tree = true;
            };
            style = {
              fg = "#91bef0";
            };
            use_treesitter = true;
          };
          indent = {
            chars = [
              "│"
            ];
            exclude_filetypes = {
              lazyterm = true;
              neo-tree = true;
            };
            style = {
              fg = "#45475a";
            };
            use_treesitter = false;
          };
          line_num = {
            style = "#91bef0";
            use_treesitter = true;
          };
        };
      };
      hmts.enable = true;
      hop.enable = true;
      hunk = {
        enable = true;
        settings = {
          hooks = {
            on_diff_mount.__raw = ''
              ---@param _context { buf: number, win: number }
              function(_context) end
            '';
          };
          on_tree_mount.__raw = ''
            ---@param _context { buf: number, tree: NuiTree, opts: table }
            function(_context) end
          '';
          keys = {
            global = {
              quit = [
                "x"
              ];
            };
          };
          ui = {
            layout = "horizontal";
            tree = {
              mode = "flat";
              width = 40;
            };
          };
        };
      };
      illuminate.enable = true;
      lazygit.enable = true;
      lint = {
        enable = true;
        lintersByFt = {
          dockerfile = ["hadolint"];
          haskell = ["hlint"];
          json = ["jq"];
          markdown = [
            "markdownlint"
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
            gen_loader.from_lang = true;
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
      nabla.enable = true;
      neogit = {
        enable = true;
        settings = {
          commit_editor.kind = "floating";
          commit_select_view.kind = "floating";
          preview_buffer.kind = "floating";
          popup.kind = "floating";
          merge_editor.kind = "floating";
          log_view.kind = "floating";
          description_editor.kind = "floating";
          rebase_editor.kind = "floating";
          reflog_view.kind = "floating";
          integrations.fzf-lua = true;
        };
      };
      neotest = {
        enable = true;
        settings = {
          diagnostic = {
            enabled = true;
            severity = "warn";
          };
          discovery = {
            enabled = true;
            concurrent = 0;
          };
          output = {
            enabled = true;
            open_on_run = "short";
          };
          quickfix = {
            enabled = true;
            open = true;
          };
        };
        adapters = {
          haskell = {
            enable = true;
            settings = {
              command = "neotest-haskell";
            };
          };
          plenary = {
            enable = true;
          };
          python = {
            enable = true;
          };
        };
      };
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
            name = "fzf-lua";
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
      oil.enable = true;
      projections = {
        enable = true;
        settings = {
          patterns = [".git"];
          workspaces = [
            "~/vaults/zettelkasten"
            "~/projects/pocketsizefund/pocketsizefund"
            "~/projects/pocketsizefund/pocketsizefund"
          ];
        };
      };
      # project-nvim = {
      #   enable = true;
      #   settings = {
      #     detection_methods = [
      #       "lsp"
      #       "pattern"
      #     ];
      #     patterns = [
      #       ".git"
      #       "package.yaml"
      #       "stack.yaml"
      #       "Cargo.toml"
      #       "pyproject.toml"
      #     ];
      #     showHidden = true;
      #     # silent_chdir = false;
      #     # scope_chdir = "win";
      #     # manual_mode = true;
      #   };
      # };
      scope = {
        enable = true;
      };
      snacks = {
        enable = true;
      };
      supermaven.enable = true;
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          c
          diff
          html
          json
          latex
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
      zen-mode = {
        enable = true;
        settings.plugins.options = {
          number = false;
          signcolumn = "no";
          tmux = {
            enabled = false;
          };
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>tf";
        action.__raw = "function()
          vim.cmd('silent! wall')
          require('neotest').run.run(vim.fn.expand('%'))
        end";
        options.desc = "Run current file";
      }
      {
        mode = "n";
        key = "<leader>tl";
        action = "<cmd>wall<cr><cmd>Neotest run last<cr>";
        options.desc = "[t]est run [l]ast";
      }
      {
        mode = "n";
        key = "<leader>mp";
        action = "<cmd>lua require('nabla').popup()<cr>";
        options.desc = "[m]ath [p]opup";
      }
      {
        mode = "n";
        key = "<leader>ta";
        action.__raw = "function()
          vim.cmd('silent! wall')
          require('neotest').run.run({vim.fn.getcwd(), strategy = 'dap'})
        end";
        options.desc = "[t]est run [a]ll";
      }
      {
        mode = "n";
        key = "<leader>tj";
        action = "<cmd>Neotest jump next<cr>";
        options.desc = "[t]est [j]ump next";
      }
      {
        mode = "n";
        key = "<leader>tk";
        action = "<cmd>Neotest jump prev<cr>";
        options.desc = "[t]est [k]ump previous";
      }
      {
        mode = "n";
        key = "<leader>to";
        action = "<cmd>Neotest output-panel toggle<cr>";
        options.desc = "[t]est [o]utput panel";
      }
      {
        mode = "n";
        key = "<leader>ts";
        action = "<cmd>Neotest summary toggle<cr>";
        options.desc = "[t]est [s]ummary";
      }
      {
        mode = "n";
        key = "<leader>tm";
        action.__raw = "function()
          -- Make sure changes are saved before running tests
          vim.cmd('silent! wall')
          require('neotest').run.run({vim.fn.expand('%'), adapter = 'haskell'})
        end";
        options.desc = "Run Haskell module tests";
      }
      {
        mode = "n";
        key = "<leader>hr";
        action = "<cmd>Haskell repl toggle<cr>";
        options.desc = "[h]askell [r]epl";
      }
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      {
        mode = "n";
        key = "<leader>c";
        action = "";
        options.desc = "[c]ode";
      }
      {
        mode = "n";
        key = "<leader>f";
        action = "";
        options.desc = "[f]ind";
      }
      {
        mode = "n";
        key = "<leader>ft";
        action = "<cmd>ObsidianSearch #todo<cr>";
        options.desc = "[f]ind [t]odo";
      }
      {
        mode = "n";
        key = "<leader>q";
        action.__raw = "vim.diagnostic.setloclist";
        options.desc = "[q]uickfix list open";
      }
      {
        mode = "n";
        key = "<leader>sf";
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
        action = "<cmd>HopAnywhere<cr>";
        options.desc = "[j]ump to [j]ust";
      }

      {
        mode = "n";
        key = "<leader>jn";
        action = "<cmd>HopNodes<cr>";
        options.desc = "[j]ump to [n]ode";
      }

      {
        mode = "n";
        key = "<leader>j/";
        action = "<cmd>HopPattern<cr>";
        options.desc = "[j]ump to [p]attern";
      }
      {
        mode = "n";
        key = "<leader>jj";
        action = "<cmd>HopLineAC<cr>";
        options.desc = "[j]ump down to line";
      }
      {
        mode = "n";
        key = "<leader>jk";
        action = "<cmd>HopLineBC<cr>";
        options.desc = "[j]ump up to line";
      }
      {
        mode = "n";
        key = "<leader>o";
        action = "<cmd>Oil<cr>";
        options.desc = "[o]il file tree";
      }
      {
        mode = "n";
        key = "<leader>mm";
        action = "<cmd>lua MiniMap.toggle()<cr><cmd>AerialToggle!<cr>";
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
        key = "<leader>cl";
        action = "<cmd>lua vim.lsp.codelens.run()<cr>";
        options.desc = "[c]ode [l]ens";
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        options.desc = "[c]ode action";
      }
      {
        mode = "n";
        key = "<leader>hs";
        action = "<cmd>lua require('haskell-tools').hoogle.hoogle_signature()<cr>";
        options.desc = "[h]askell [signature]";
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>Neogit<cr>";
        options.desc = "[g]it";
      }
      {
        mode = "n";
        key = "<leader>gl";
        action = "<cmd>LazyGit<cr>";
        options.desc = "[g]it [l]azygit";
      }
      {
        mode = "n";
        key = "<leader>f<leader>";
        action = "<cmd>FzfLua<cr>";
        options.desc = "[f]ind menu";
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
        key = "<leader>zm";
        action = "<cmd>Goyo<cr><cmd>Limelight!!<cr><cmd>ZenMode<cr>";
        options.desc = "[z]en [m]ode";
      }
    ];
  };
}
