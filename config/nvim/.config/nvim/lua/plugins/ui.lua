return {
  { "nvim-tree/nvim-web-devicons", opts = {} },

  { "nvim-lualine/lualine.nvim", opts = {} },

  { "j-hui/fidget.nvim", opts = {} },

  { "xiyaowong/transparent.nvim", opts = {} },

  { "folke/snacks.nvim", opts = {} },

  {
    "stevearc/aerial.nvim",
    opts = {
      attach_mode = "global",
      backends = { "treesitter", "lsp", "markdown" },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>a", group = "[a]vante" },
        { "<leader>c", group = "[c]laude" },
        { "<leader>f", group = "[f]ind" },
        { "<leader>fd", group = "[d]iagnostics" },
        { "<leader>g", group = "[g]it" },
        { "<leader>h", group = "[h]arpoon" },
        { "<leader>t", group = "[t]erminal" },
      },
    },
  },
}
