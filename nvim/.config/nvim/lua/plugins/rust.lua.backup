return {
	'mrcjkb/rustaceanvim',
	version = '^6',
	lazy = false,
	ft = { 'rust' },
	config = function()
		vim.g.rustaceanvim = {
			tools = {
				hover_actions = {
					auto_focus = false,
				},
			},
			server = {
				auto_attach = true,
				settings = {
					['rust-analyzer'] = {
						checkOnSave = true,
						cargo = {
							allFeatures = true,
						},
					},
				},

				on_attach = function(client, bufnr)
					vim.keymap.set("n", "<leader>ca", function()
						vim.cmd.RustLsp('codeAction')
					end, { buffer = bufnr, desc = "Rust code action" })

					vim.keymap.set("n", "<leader>dr", function()
						vim.cmd.RustLsp('debuggables')
					end, { buffer = bufnr, desc = "Rust debuggables" })
				end,
			},
			-- dap = {},
		}
	end,
}
