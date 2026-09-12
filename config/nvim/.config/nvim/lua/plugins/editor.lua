return {
  {
    "stevearc/oil.nvim",

    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },
      })
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },

  { "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {} },

  {
    "voldikss/vim-floaterm",
    init = function()
      vim.g.floaterm_height = 0.9
      vim.g.floaterm_width = 0.9
      vim.g.floaterm_keymap_kill = "<leader>tk"
      vim.g.floaterm_keymap_new = "<leader>tn"
    end,
  },

  { "Canop/nvim-bacon", opts = {} },
}
