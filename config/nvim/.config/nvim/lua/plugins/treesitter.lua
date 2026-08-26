return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- "main" is the rewritten branch with a different, setup()-less API; stay
    -- on "master" for the classic `nvim-treesitter.configs` module below.
    branch = "master",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "nix",
        "ocaml",
        "ocaml_interface",
        "python",
        "rust",
        "toml",
        "yaml",
      },
      highlight = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
