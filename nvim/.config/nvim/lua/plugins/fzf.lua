return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-mini/mini.icons" },
	opts = {},
	config = function()
		local wk = require("which-key")
		require("fzf-lua").setup({
			winopts = {
				col = 0.3,
				height = 0.9,
				row = 0.99,
				width = 0.93,
			},

			buffers = {
				prompt = "Buffers❯ ",
				color_icons = true,
				sort_lastused = true,
			},
			files = {
				color_icons = true,
				file_icons = true,
				git_icons = true,
				find_opts = [[-type f -not -path '*.git/objects*' -not -path '*.env*']],
				multiprocess = true,
				prompt = "Files❯ ",
			},
		})
		wk.add({
			{ "<leader>f", group = "find" },
			{ "<leader>f<leader>", "<cmd>FzfLua<CR>", desc = "fzf menu" },
			{ "<leader><leader>", "<cmd>FzfLua buffers<CR>", desc = "buffers" },
			{ "<leader>fc", "<cmd>FzfLua command_history<CR>", desc = "command history" },
			{ "<leader>ff", "<cmd>FzfLua files<CR>", desc = "files" },
			{ "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "grep" },
			{ "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "keymaps" },
			{ "<leader>fm", "<cmd>FzfLua marks<CR>", desc = "marks" },
			{ "<leader>fr", "<cmd>FzfLua registers<CR>", desc = "registers" },
		})
	end,
}
