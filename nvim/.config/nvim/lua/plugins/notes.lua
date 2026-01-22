return {
	'renerocksai/telekasten.nvim',
	dependencies = {
		'nvim-telescope/telescope.nvim',
		'nvim-telescope/telescope-media-files.nvim',
		'folke/which-key.nvim',
	},
	config = function()
		local notes_home = vim.fn.expand("~/wiki")

		-- Telekasten
		require('telekasten').setup({
			home = notes_home,
		})

		-- Telescope: load media_files extension
		local telescope = require("telescope")
		telescope.setup({
			extensions = {
				media_files = {
					-- filetypes to preview
					filetypes = { "png", "jpg", "jpeg", "gif", "webp", "pdf" },
					-- use rg to find files
					find_cmd = "rg",
				},
			},
		})
		telescope.load_extension("media_files")

		-- Which-key mappings
		local wk = require("which-key")

		wk.add({
			-- top-level notes group
			{ "<leader>n",  group = "notes" },

			{
				"<leader>np",
				"<cmd>Telekasten panel<CR>",
				desc = "Notes Panel",
			},
			{
				"<leader>nl",
				"<cmd>Telekasten follow_link<CR>",
				desc = "notes follow link",
			},

			-- todos subgroup under <leader>nt
			{ "<leader>nt", group = "todos" },

			{
				"<leader>ntt",
				function()
					require("telekasten").toggle_todo()
				end,
				desc = "Toggle TODO",
			},
			{
				"<leader>nts",
				function()
					require("telescope.builtin").grep_string({
						search = "- [ ]",
						cwd = notes_home,
					})
				end,
				desc = "Search open TODOs",
			},

			-- media subgroup under <leader>nm
			{ "<leader>nm", group = "media" },

			-- n m i → browse images in wiki
			{
				"<leader>nmi",
				function()
					telescope.extensions.media_files.media_files({
						cwd = notes_home, -- search in your wiki root
					})
				end,
				desc = "Browse images in notes",
			},
		})
	end,
}
