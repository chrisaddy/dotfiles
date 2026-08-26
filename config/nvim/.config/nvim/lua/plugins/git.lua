return {
  { "lewis6991/gitsigns.nvim", opts = {} },

  { "NeogitOrg/neogit", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },

  {
    "pwntester/octo.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- Default picker is telescope, which isn't installed here; fzf-lua is.
    opts = { picker = "fzf-lua" },
  },

  {
    -- No Lua setup() function: configuration is all vim.g globals.
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      vim.g.lazygit_floating_window_scaling_factor = 1.0
    end,
  },

  -- BEST-EFFORT GUESS: nixvim's "codediff" plugin module maps to a
  -- `:CodeDiff` command (see keymaps.lua's <leader>gd), but its exact
  -- upstream repo could not be confirmed offline. Verify the source below
  -- before relying on it.
  -- { "some-author/codediff.nvim", opts = {} },
}
