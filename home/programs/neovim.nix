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

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      expandtab = true;
      ignorecase = true;
      smartcase = true;
    };

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
      fidget.enable = true;
      # flash.enable = true;
      fzf-lua.enable = true;
      gitsigns.enable = true;
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
          json
          lua
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
