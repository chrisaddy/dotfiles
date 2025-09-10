return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"ibhagwan/fzf-lua",
		},
		config = function()
			local wk = require("which-key")
			require("neogit").setup({

				commit_editor = {
					kind = "floating",
				},
				commit_select_view = {
					kind = "floating",
				},

				preview_buffer = {
					kind = "floating",
				},
				popup = {
					kind = "floating",
				},
				merge_editor = {
					kind = "floating",
				},
				log_view = {
					kind = "floating",
				},
				description_editor = {
					kind = "floating",
				},
				rebase_editor = {
					kind = "floating",
				},
				reflog_view = {
					kind = "floating",
				},
				integrations = {
					fzf_lua = true,
				},
			})
			wk.add({
				"<leader>gg",
				"<cmd>Neogit<cr>",
				desc = "[g]it",
			})
		end,
	},
}
