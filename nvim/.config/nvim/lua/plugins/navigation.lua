return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		lazy = false,
		config = function()
			require("oil").setup({
				delete_to_trash = true,
			})
			require("which-key").add({ "<leader>o", "<cmd>Oil<CR>", desc = "Open parent directory with oil" })
		end,
	},
	{
		"stevearc/aerial.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("aerial").setup({
				attach_mode = "global",
				backends = { "treesitter", "lsp", "markdown", "man" },
				ignore = {
					filetypes = { "gomod" },
				},
				close_behavior = "auto",
				default_bindings = true,
				default_direction = "auto",
				highlight_mode = "split",
				highlight_closest = true,
				max_width = 0.1,
				name = "aerial",
				open_automatic = false,
				position = "left",
				show_guides = true,
				sort = true,
				symbol_filter = false,
				toggle_auto_fold = true,
				tree_width = 30,
				use_default_mappings = true,
				use_icons = true,
				width = 30,
			})
			require("which-key").add({ "<leader>et", "<cmd>AerialToggle<cr>", desc = "Toggle aerial" })
		end,
	},
	{
		"jiaoshijie/undotree",
		dependencies = { "nvim-lua/plenary.nvim" },
		---@module 'undotree.collector'
		---@type UndoTreeCollector.Opts
		opts = {},
		config = function()
			require("undotree").setup({})
			require("which-key").add({
				"<leader>u",
				"<cmd>lua require('undotree').toggle()<cr>",
				desc =
				"Toggle undotree"
			})
		end,
	},
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("hlchunk").setup({})
		end,
	},
}
