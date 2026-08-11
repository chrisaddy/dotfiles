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

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      expandtab = true;
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
        options.desc = "[O]pen parent directory";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<CMD>:FzfLua files<CR>";
        options.desc = "[F]ind [F]iles";
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = "<CMD>BlameToggle<CR>";
        options.desc = "[G]it [B]lame";
      }
      {
        mode = "n";
        key = "<leader>gd";
        action = "<CMD>CodeDiff<CR>";
        options.desc = "[G]it [D]iff";
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<CMD>LazyGit<CR>";
        options.desc = "Lazy [G]it";
      }
      {
        mode = "n";
        key = "<leader>w";
        action = "<CMD>w<CR>";
        options.desc = "[W]rite File";
      }
    ];

    plugins = {
      aerial.enable = true;
      avante.enable = true;
      bacon.enable = true;
      blame.enable = true;
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
      flash.enable = true;
      fzf-lua.enable = true;
      gitsigns.enable = true;
      lualine.enable = true;
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
      telescope.enable = true;
      web-devicons.enable = true;
      snacks.enable = true;
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
            group = "[A]vante";
          }
          {
            __unkeyed-1 = "<leader>f";
            group = "[F]ind";
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "[G]it";
          }
          {
            __unkeyed-1 = "<leader>t";
            group = "[T]erminal";
          }
        ];
      };
    };
  };

in
{
  home.packages = [ nixvimPkg ];
}
