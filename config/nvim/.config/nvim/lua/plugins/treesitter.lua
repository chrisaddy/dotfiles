return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- "master" is archived and no longer compatible with current Neovim
    -- treesitter internals (injections crash on markdown/markdown_inline).
    -- "main" is the rewrite: no more `nvim-treesitter.configs`, parsers are
    -- installed explicitly and highlighting is started per-filetype.
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local parsers = {
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
      }
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "bash",
          "json",
          "lua",
          "markdown",
          "nix",
          "ocaml",
          "python",
          "rust",
          "toml",
          "yaml",
        },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
