{
  config,
  pkgs,
  nixvim,
  ...
}:
let
  nixvimPkg = nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvim {
    viAlias = true;
    vimAlias = true;

    # flake.nix makes nixvim's nixpkgs `follows` ours, so nixvim's own pin no
    # longer matches. Pointing `nixpkgs.source` at the nixpkgs we actually
    # build against silences its mismatch warning.
    nixpkgs.source = pkgs.path;

    # `makeNixvim` defaults this to false, which makes the wrapper pass a ~600
    # char multi-line `--cmd "lua ..."` argument to hide XDG/system config dirs
    # at startup. Zellij's session resurrection records that argv verbatim and
    # renders it as the pane frame title, which then overflows the frame. There
    # is no `~/.config/nvim` here, so keeping the XDG dirs in the runtimepath
    # costs nothing and keeps the command line to a single store path.
    impureRtp = true;

    globals.mapleader = " ";

    # claudecode.nvim's nixvim module enables this, which both drags an unfree
    # nixpkgs claude-code into the closure and puts its pinned version on nvim's
    # PATH ahead of the self-updating CLI in ~/.local/bin. `terminal_cmd` names
    # that CLI directly, so the packaged one is redundant.
    dependencies.claude-code.enable = false;

    clipboard = {
      register = "unnamedplus";
    };

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      expandtab = true;
      ignorecase = true;
      smartcase = true;
    };

    # Errors show inline, in the sign column, and in a float on hover, worst
    # first. clangd's clang-tidy checks arrive through the same channel.
    diagnostic.settings = {
      severity_sort = true;
      virtual_text.source = "if_many";
      float.source = true;
      underline = true;
    };

    # `:make` parses compiler output with 'errorformat', whose default already
    # understands gcc/clang. Open the quickfix list only when there is
    # something in it; `]q`/`[q` (nvim built-ins) walk it.
    autoCmd = [
      {
        event = "QuickFixCmdPost";
        pattern = "[^l]*";
        command = "cwindow";
      }
    ];

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "macchiato";
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>cc";
        action = "<CMD>ClaudeCode<CR>";
        options.desc = "toggle [c]laude";
      }
      {
        mode = "n";
        key = "<leader>cf";
        action = "<CMD>ClaudeCodeFocus<CR>";
        options.desc = "[f]ocus claude";
      }
      {
        mode = "n";
        key = "<leader>cb";
        action = "<CMD>ClaudeCodeAdd %<CR>";
        options.desc = "add [b]uffer to context";
      }
      # Visual-mode send is the point of the WebSocket bridge: the selection
      # arrives as an @-mention rather than pasted text.
      {
        mode = "v";
        key = "<leader>cs";
        action = "<CMD>ClaudeCodeSend<CR>";
        options.desc = "[s]end selection to claude";
      }
      {
        mode = "n";
        key = "<leader>cy";
        action = "<CMD>ClaudeCodeDiffAccept<CR>";
        options.desc = "accept diff ([y]es)";
      }
      {
        mode = "n";
        key = "<leader>cn";
        action = "<CMD>ClaudeCodeDiffDeny<CR>";
        options.desc = "deny diff ([n]o)";
      }
      # nvim 0.11+ already maps grn/gra/grr/gri/K/[d/]d; these fill the gaps.
      {
        mode = "n";
        key = "gd";
        action.__raw = "vim.lsp.buf.definition";
        options.desc = "goto [d]efinition";
      }
      {
        mode = "n";
        key = "<leader>e";
        action.__raw = "vim.diagnostic.open_float";
        options.desc = "show [e]rror";
      }
      {
        mode = "n";
        key = "<leader>m";
        action = "<CMD>make<CR>";
        options.desc = "[m]ake (errors to quickfix)";
      }
      {
        mode = "n";
        key = "<leader>db";
        action.__raw = ''function() require("dap").toggle_breakpoint() end'';
        options.desc = "toggle [b]reakpoint";
      }
      {
        mode = "n";
        key = "<leader>dc";
        action.__raw = ''function() require("dap").continue() end'';
        options.desc = "start/[c]ontinue";
      }
      {
        mode = "n";
        key = "<leader>dn";
        action.__raw = ''function() require("dap").step_over() end'';
        options.desc = "step over ([n]ext)";
      }
      {
        mode = "n";
        key = "<leader>di";
        action.__raw = ''function() require("dap").step_into() end'';
        options.desc = "step [i]nto";
      }
      {
        mode = "n";
        key = "<leader>do";
        action.__raw = ''function() require("dap").step_out() end'';
        options.desc = "step [o]ut";
      }
      {
        mode = "n";
        key = "<leader>dr";
        action.__raw = ''function() require("dap").run_to_cursor() end'';
        options.desc = "[r]un to cursor";
      }
      {
        mode = "n";
        key = "<leader>dq";
        action.__raw = ''function() require("dap").terminate() end'';
        options.desc = "[q]uit session";
      }
      {
        mode = "n";
        key = "<leader>du";
        action.__raw = ''function() require("dapui").toggle() end'';
        options.desc = "toggle [u]i";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>de";
        action.__raw = ''function() require("dapui").eval() end'';
        options.desc = "[e]valuate expression";
      }
      {
        mode = "n";
        key = "<leader>o";
        action = "<CMD>Oil<CR>";
        options.desc = "[o]pen parent directory";
      }
      {
        mode = "n";
        key = "<leader>fdb";
        action = "<CMD>FzfLua diagnostics_document<CR>";
        options.desc = "[b]uffer";
      }
      {
        mode = "n";
        key = "<leader>fdq";
        action = "<CMD>FzfLua quickfix<CR>";
        options.desc = "[q]uickfix";
      }
      {
        mode = "n";
        key = "<leader>fdw";
        action = "<CMD>FzfLua diagnostics_workspace<CR>";
        options.desc = "[w]orkspace";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<CMD>FzfLua files<CR>";
        options.desc = "[f]iles";
      }
      {
        mode = "n";
        key = "<leader>fs";
        action = "<CMD>FzfLua live_grep<CR>";
        options.desc = "[s]earch";
      }
      {
        mode = "n";
        key = "<leader>fm";
        action = "<CMD>FzfLua marks<CR>";
        options.desc = "[m]arks";
      }
      {
        mode = "n";
        key = "<leader>fM";
        action = "<CMD>FzfLua<CR>";
        options.desc = "[M]enu";
      }
      {
        mode = "n";
        key = "<leader>fr<CR>";
        action = "<CMD>FzfLua registers";
        options.desc = "[r]egisters";
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = "<CMD>FzfLua git_branches<CR>";
        options.desc = "[b]ranches";
      }
      {
        mode = "n";
        key = "<leader>gB";
        action = "<CMD>FzfLua git_blame<CR>";
        options.desc = "[B]lame";
      }
      {
        mode = "n";
        key = "<leader>gc";
        action = "<CMD>FzfLua git_commits";
        options.desc = "[c]ommits";
      }
      {
        mode = "n";
        key = "<leader>gd";
        action = "<CMD>CodeDiff<CR>";
        options.desc = "[d]iff";
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<CMD>LazyGit<CR>";
        options.desc = "Lazy [g]it";
      }
      {
        mode = "n";
        key = "<leader>gh";
        action = "<CMD>FzfLua git_hunks<CR>";
        options.desc = "[h]unks";
      }
      {
        mode = "n";
        key = "<leader>gs";
        action = "<CMD>FzfLua git_status<CR>";
        options.desc = "[s]tatus";
      }
      {
        mode = "n";
        key = "<leader>gw";
        action = "<CMD>FzfLua git_worktrees<CR>";
        options.desc = "[w]orktrees";
      }
      # harpoon2 exposes `list` and `ui` as objects with colon-methods, so these
      # have to be raw lua closures — there is no `:Harpoon` command, and a
      # dot-call like `harpoon.ui.toggle_quick_menu()` passes no `self`.
      {
        mode = "n";
        key = "<leader>ha";
        action.__raw = ''function() require("harpoon"):list():add() end'';
        options.desc = "[a]dd file";
      }
      {
        mode = "n";
        key = "<leader>hh";
        action.__raw = ''
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end
        '';
        options.desc = "toggle quick menu";
      }
      {
        mode = "n";
        key = "<leader>hn";
        action.__raw = ''function() require("harpoon"):list():next() end'';
        options.desc = "[n]ext mark";
      }
      {
        mode = "n";
        key = "<leader>hp";
        action.__raw = ''function() require("harpoon"):list():prev() end'';
        options.desc = "[p]revious mark";
      }
      {
        mode = "n";
        key = "<leader>h1";
        action.__raw = ''function() require("harpoon"):list():select(1) end'';
        options.desc = "mark 1";
      }
      {
        mode = "n";
        key = "<leader>h2";
        action.__raw = ''function() require("harpoon"):list():select(2) end'';
        options.desc = "mark 2";
      }
      {
        mode = "n";
        key = "<leader>h3";
        action.__raw = ''function() require("harpoon"):list():select(3) end'';
        options.desc = "mark 3";
      }
      {
        mode = "n";
        key = "<leader>h4";
        action.__raw = ''function() require("harpoon"):list():select(4) end'';
        options.desc = "mark 4";
      }
      {
        mode = "n";
        key = "<leader>u";
        action = "<CMD>FzfLua undotree<CR>";
        options.desc = "[u]ndotree";
      }
      {
        mode = "n";
        key = "<leader>w";
        action = "<CMD>w<CR>";
        options.desc = "[w]rite File";
      }
    ];

    plugins = {
      aerial = {
        enable = true;
        settings = {
          attach_mode = "global";
          backends = [
            "treesitter"
            "lsp"
            "markdown"
          ];
        };
      };
      # avante = {
      #   enable = true;
      #   settings = {
      #     provider = "claude";
      #     behaviour = {
      #       auto_suggestions = true;
      #     };
      #     inputs = {
      #       provider = "snacks";
      #       provider_opts = {
      #         title = "Avante Input";
      #         icon = " ";
      #       };
      #     };
      #   };
      # };
      bacon.enable = true;
      blink-cmp = {
        enable = true;
        settings = {
          # Supermaven owns <Tab>. blink applies its keymaps buffer-locally on
          # InsertEnter, which beats supermaven's global insert-mode map, so the
          # preset's `snippet_forward` would otherwise get first refusal on every
          # Tab. Leaving only `fallback` here makes blink hand the key straight to
          # supermaven; snippet_forward moves to <C-l>, and <S-Tab> keeps the
          # preset's snippet_backward (supermaven does not map it).
          #
          # This also has to be a real handoff rather than relying on
          # supermaven's own fallback: when it has no suggestion it feedkeys a
          # noremap <Tab>, which inserts a literal tab and never reaches blink.
          keymap = {
            preset = "default";
            "<Tab>" = [ "fallback" ];
            "<C-l>" = [
              "snippet_forward"
              "fallback"
            ];
          };
          sources = {
            default = [
              "lsp"
              "path"
              "buffer"
              "avante"
            ];
            providers = {
              avante = {
                module = "blink-cmp-avante";
                name = "Avante";
              };
            };
          };
        };
      };
      blink-cmp-avante.enable = true;
      blink-pairs.enable = true;
      # Talks to the Claude Code CLI over a WebSocket, so the Max subscription is
      # used through Anthropic's own client rather than by presenting Claude
      # Code's OAuth client_id from another program.
      claudecode = {
        enable = true;
        settings = {
          # `dependencies.claude-code` is disabled above, so nothing puts a
          # packaged CLI on nvim's PATH; name the self-updating one in
          # ~/.local/bin directly.
          terminal_cmd = "${config.home.homeDirectory}/.local/bin/claude";
        };
      };
      codediff.enable = true;
      floaterm = {
        enable = true;
        settings = {
          height = 0.9;
          width = 0.9;
          keymap_kill = "<leader>tk";
          keymap_new = "<leader>tn";
        };
      };
      # lldb-dap is LLVM's own DAP adapter and ships with the `lldb` package.
      # Build with -g (and ideally -O0) so there is debug info to step through.
      dap = {
        enable = true;
        adapters.executables.lldb.command = "${pkgs.lldb}/bin/lldb-dap";
        configurations.c = [
          {
            name = "Launch";
            type = "lldb";
            request = "launch";
            program.__raw = ''
              function()
                return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
              end
            '';
            args.__raw = ''
              function()
                return vim.split(vim.fn.input("Args: "), " ", { trimempty = true })
              end
            '';
            cwd = "\${workspaceFolder}";
            stopOnEntry = false;
          }
        ];
        # Open the variables/stack/breakpoints panes for the life of a session.
        luaConfig.post = ''
          local dap, dapui = require("dap"), require("dapui")
          dap.listeners.after.event_initialized.dapui = function() dapui.open() end
          dap.listeners.before.event_terminated.dapui = function() dapui.close() end
          dap.listeners.before.event_exited.dapui = function() dapui.close() end
        '';
      };
      dap-ui.enable = true;
      dap-virtual-text.enable = true;
      fidget.enable = true;
      # flash.enable = true;
      fzf-lua.enable = true;
      gitsigns.enable = true;
      harpoon.enable = true;
      lualine.enable = true;
      neogit.enable = true;
      octo.enable = true;
      oil.enable = true;
      lazygit = {
        enable = true;
        settings = {
          floating_window_scaling_factor = 1.0;
        };
      };
      lsp = {
        enable = true;
        servers = {
          basedpyright.enable = true;
          bashls.enable = true;
          # Reads compile_commands.json (e.g. `bear -- make`, or CMake's
          # CMAKE_EXPORT_COMPILE_COMMANDS) for flags and include paths.
          clangd = {
            enable = true;
            cmd = [
              "clangd"
              "--background-index"
              "--clang-tidy"
              "--header-insertion=never"
            ];
          };
          docker_compose_language_service.enable = true;
          dockerls.enable = true;
          ghcide.enable = true;
          helm_ls.enable = true;
          html.enable = true;
          htmx.enable = true;
          just.enable = true;
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
          sqruff.enable = true;
          ty.enable = true;
          yamlls.enable = true;
        };
      };
      lsp-format.enable = true;
      transparent.enable = true;
      web-devicons.enable = true;
      snacks.enable = true;
      # Inline (ghost text) completion, the half of Cody that claudecode does not
      # cover. The free tier needs a one-off `:SupermavenUseFree`; no credential
      # is stored in this repo.
      supermaven = {
        enable = true;
        settings = {
          keymaps = {
            accept_suggestion = "<Tab>";
            accept_word = "<C-j>";
            clear_suggestions = "<C-]>";
          };
        };
      };
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          c
          json
          lua
          make
          markdown
          markdown_inline
          nix
          ocaml
          ocaml_interface
          python
          rust
          toml
          yaml
        ];
      };
      which-key = {
        enable = true;
        settings.spec = [
          {
            __unkeyed-1 = "<leader>a";
            group = "[a]vante";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "[c]laude";
          }
          {
            __unkeyed-1 = "<leader>d";
            group = "[d]ebug";
          }
          {
            __unkeyed-1 = "<leader>f";
            group = "[f]ind";
          }
          {
            __unkeyed-1 = "<leader>fd";
            group = "[d]iagnostics";
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "[g]it";
          }
          {
            __unkeyed-1 = "<leader>h";
            group = "[h]arpoon";
          }
          {
            __unkeyed-1 = "<leader>t";
            group = "[t]erminal";
          }
        ];
      };
    };
  };

in
{
  home.packages = [ nixvimPkg ];
}
