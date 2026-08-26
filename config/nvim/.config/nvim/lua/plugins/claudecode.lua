return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- Names the self-updating Claude Code CLI in ~/.local/bin directly,
      -- rather than a nixpkgs-pinned one on nvim's PATH.
      terminal_cmd = vim.fn.expand("~/.local/bin/claude"),
    },
  },
}
