return {
	"jiaoshijie/undotree",
	dependencies = { "nvim-lua/plenary.nvim" },
	---@module 'undotree.collector'
	---@type UndoTreeCollector.Opts
	opts = {},
	config = function()
		local wk = require("which-key")
		require("undotree").setup({})
		wk.add({ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" })
	end,
}
