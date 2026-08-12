{
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
      avante = {
        enable = true;
        settings = {
          providers = {
            claude = {
              auth_type = "max";
            };
          };
          inputs = {
            provider = "snacks";
            provider_opts = {
              title = "Avante Input";
              icon = " ";
            };
          };
        };
      };
      bacon.enable = true;
      blink-cmp = {
        enable = true;
        settings = {
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
      supermaven.enable = true;
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
