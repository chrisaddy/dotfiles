return {
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")

			lspconfig.bashls.setup({})
			lspconfig.dockerls.setup({})
			lspconfig.docker_compose_language_service.setup({})
			lspconfig.lua_ls.setup({})
			lspconfig.html.setup({})
			lspconfig.jqls.setup({})
			lspconfig.markdown_oxide.setup({})
			lspconfig.nixd.setup({})
			lspconfig.nushell.setup({})
			lspconfig.postgres_lsp.setup({})
			lspconfig.ruff.setup({})
			lspconfig.sqls.setup({})
			lspconfig.yamlls.setup({})
			-- python
			lspconfig.basedpyright.setup({})
			lspconfig.ruff.setup({})
			-- rust
			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {},
				},
			})
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }
					vim.keymap.set(
						"n",
						"gD",
						vim.lsp.buf.declaration,
						vim.tbl_extend("force", opts, { desc = "go to declaration" })
					)
					vim.keymap.set(
						"n",
						"gd",
						vim.lsp.buf.definition,
						vim.tbl_extend("force", opts, { desc = "go to definition" })
					)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				end,
			})
		end,
	},
	{
		"nvim-mini/mini.completion",
		config = function()
			require("mini.completion").setup({})
		end,
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				notify_on_error = true,
				notify_no_formatters = true,
				formatters_by_ft = {
					bash = {
						"shellcheck",
						"shellharden",
						"shfmt",
					},
					docker = { "dockerfmt" },
					gerkin = { "ghokin" },
					go = { "gofmt" },
					haskell = { "hindent", "stylish-haskell" },
					html = { "html_beautify" },
					json = { "jq" },
					just = { "just" },
					lua = { "stylua", "lua-format" },
					markdown = { "markdownlint-cli2" },
					nix = { "alejandra", "nixpkgs-fmt" },
					nu = { "nufmt" },
					pyproject = { "pyproject-fmt" },
					python = { "isort", "ruff" },
					sql = { "sqlfmt" },
					yaml = { "yamlfmt", "yq" },
					_ = {
						"squeeze_blanks",
						"trim_whitespace",
						"trim_newlines",
					},
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},
}
