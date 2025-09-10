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
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"dockerls",
					"docker_compose_language_service",
					"lua_ls",
					"html",
					"markdown_oxide",
					"postgres_lsp",
					"ruff",
					"yamlls",
					"basedpyright",
				},
				automatic_installation = true,
			})

			local lspconfig = require("lspconfig")

			lspconfig.bashls.setup({})
			lspconfig.dockerls.setup({})
			lspconfig.docker_compose_language_service.setup({})
			lspconfig.lua_ls.setup({})
			lspconfig.html.setup({})
			lspconfig.markdown_oxide.setup({})
			lspconfig.postgres_lsp.setup({})
			lspconfig.yamlls.setup({})
			-- python
			lspconfig.basedpyright.setup({})
			lspconfig.ruff.setup({})
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
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				actionlint = { "actionlint" },
				dockerfile = { "hadolint" },
				haskell = { "hlint" },
				json = { "jq" },
				lua = { "luacheck" },
				markdown = { "markdownlint-cli2" },
				python = { "ruff" },
				text = { "vale" },
			}
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
	{
		"AckslD/nvim-FeMaco.lua",
		config = function()
			require("femaco").setup({})
			require("which-key").add({ "<leader>cb", "<cmd>FeMaco<cr>", desc = "code block editor" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				ensure_installed = {
					"bash",
					"c",
					"diff",
					"html",
					"json",
					"latex",
					"lua",
					"luadoc",
					"make",
					"markdown",
					"markdown_inline",
					"nix",
					"regex",
					"query",
					"sql",
					"terraform",
					"toml",
					"vim",
					"vimdoc",
					"xml",
					"yaml",
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
				},
			})
		end,
		--       treesitter-textobjects = {
		--         enable = true;
		--         lspInterop.enable = true;
		--         move.enable = true;
		--         select.enable = true;
		--       };
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		config = function()
			require("trouble").setup({})
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				update_in_insert = false,
				underline = true,
				severity_sort = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})
		end,
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix List (Trouble)" },
		},
	}
}
