return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,
	config = function()
		local wk = require("which-key")
		require("oil").setup({
			delete_to_trash = true,
		})
		wk.add({ "<leader>o", "<cmd>Oil<CR>", desc = "Open parent directory with oil" })
	end,
}
