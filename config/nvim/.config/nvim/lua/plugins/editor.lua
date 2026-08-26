return {
  { "stevearc/oil.nvim", opts = {} },

  { "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },

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

  -- BEST-EFFORT GUESS: nixvim's "bacon" plugin module is believed to map to
  -- Canop/nvim-bacon (quickfix integration for the `bacon` Rust background
  -- compiler), but the exact upstream repo could not be confirmed offline.
  -- Verify the source below before relying on it.
  { "Canop/nvim-bacon", opts = {} },
}
