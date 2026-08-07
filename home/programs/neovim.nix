{
  pkgs,
  nixvim,
  ...
}: let
  # A second, fully declarative neovim built by nixvim. Installed as `nixvim`
  # rather than `nvim` so it can be evaluated side by side with the AstroNvim
  # config below; to migrate, point `nvim` at this and drop pkgs.neovim.
  nixvimPkg = nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvim {
    # `nvim`/`vim`/`vi` stay with AstroNvim for now.
    viAlias = false;
    vimAlias = false;

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      expandtab = true;
    };

    # Catppuccin Macchiato, matching the flavour ghostty.nix asks for. Note
    # AstroNvim is not a useful reference here: its astroui.lua is disabled
    # (`if true then return {} end`), so it falls back to astrodark, which has
    # no nixvim colorscheme module.
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "macchiato";
    };

    # Mirrors the AstroNvim binding: <leader>i opens oil in the parent dir.
    keymaps = [
      {
        mode = "n";
        key = "<leader>i";
        action = "<CMD>Oil<CR>";
        options.desc = "Open parent directory";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<CMD>:Telescope find_files<CR>";
        options.desc = "[F]ind [F]iles";
      }
    ];

    # Deliberately small starter set — enough to judge nixvim, not a port of
    # the AstroNvim setup. Grow it here as Nix options.
    plugins = {
      lualine.enable = true;
      oil.enable = true;
      telescope.enable = true;
      web-devicons.enable = true;
      which-key.enable = true;

      treesitter = {
        enable = true;
        # Default is every grammar nixpkgs ships (hundreds of derivations).
        # Pin an explicit set instead.
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
    };
  };

  # Give a package a single differently-named entry point without rebuilding it.
  linkAs = name: target:
    pkgs.runCommand "nvim-as-${name}" {} ''
      mkdir -p $out/bin
      ln -s ${target} $out/bin/${name}
    '';
in {
  home.packages = [
    # Plain neovim. Its config lives in ~/.config/nvim (AstroNvim, managed by
    # lazy.nvim) and is intentionally NOT managed by Home Manager —
    # `programs.neovim.enable` would overwrite init.lua with a provider stub
    # and stop AstroNvim from loading.
    pkgs.neovim

    # `vim` as a real binary rather than a zsh alias, so scripts, git, and
    # `sudo -e` resolve it too.
    (linkAs "vim" "${pkgs.neovim}/bin/nvim")

    (linkAs "nixvim" "${nixvimPkg}/bin/nvim")
  ];
}
