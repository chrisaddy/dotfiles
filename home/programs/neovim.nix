{ config, ... }:

{
  xdg.configFile."nvim/init.lua".text = ''
    require("config.lazy")

    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.mouse = "a"
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "
    vim.o.showmode = false
    vim.schedule(function()
    	vim.o.clipboard = "unnamedplus"
    end)
    vim.o.breakindent = true
    vim.o.undofile = true
    vim.o.ignorecase = true
    vim.o.smartcase = true
    vim.o.signcolumn = "yes"
    vim.o.updatetime = 250
    vim.o.timeoutlen = 300
    vim.o.splitright = true
    vim.o.splitbelow = true
    vim.o.list = true
    vim.opt.listchars = {
    	tab = "» ",
    	trail = "·",
    	nbsp = "␣",
    }
    vim.o.inccommand = "split"
    vim.o.cursorline = true
    vim.o.scrolloff = 10
    vim.o.termguicolors = true

    require("lazy").setup({
    	spec = {
    		{ import = "plugins" },
    	},
    	checker = { enabled = true },
    })
  '';

  xdg.configFile."nvim/lua/config/lazy.lua".text = ''
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
    	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    	if vim.v.shell_error ~= 0 then
    		vim.api.nvim_echo({
    			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
    			{ out, "WarningMsg" },
    			{ "\nPress any key to exit..." },
    		}, true, {})
    		vim.fn.getchar()
    		os.exit(1)
    	end
    end
    vim.opt.rtp:prepend(lazypath)
  '';

  xdg.configFile."nvim/lazy-lock.json".text = builtins.toJSON {
    "aerial.nvim" = { branch = "master"; commit = "645d108a5242ec7b378cbe643eb6d04d4223f034"; };
    "conform.nvim" = { branch = "master"; commit = "40dcec5555f960b0a04340d76eabdf4efe78599d"; };
    "diffview.nvim" = { branch = "main"; commit = "4516612fe98ff56ae0415a259ff6361a89419b0a"; };
    "fzf-lua" = { branch = "main"; commit = "1eba927866251bae1b61dffc5b673b8dbd0f3f48"; };
    "lazy.nvim" = { branch = "main"; commit = "306a05526ada86a7b30af95c5cc81ffba93fef97"; };
    "lazydev.nvim" = { branch = "main"; commit = "5231c62aa83c2f8dc8e7ba957aa77098cda1257d"; };
    "mason-lspconfig.nvim" = { branch = "main"; commit = "a324581a3c83fdacdb9804b79de1cbe00ce18550"; };
    "mason-tool-installer.nvim" = { branch = "main"; commit = "443f1ef8b5e6bf47045cb2217b6f748a223cf7dc"; };
    "mason.nvim" = { branch = "main"; commit = "44d1e90e1f66e077268191e3ee9d2ac97cc18e65"; };
    "mini.completion" = { branch = "main"; commit = "4f94cafdeef02bf3ef9997cd6862658801caa22c"; };
    "mini.icons" = { branch = "main"; commit = "5b9076dae1bfbe47ba4a14bc8b967cde0ab5d77e"; };
    "mini.starter" = { branch = "main"; commit = "cdf909e5bda577e09c61fa6d9a36bb2a88dbc636"; };
    "neogit" = { branch = "master"; commit = "7073f3aafc9030d457838995106784a9d1873b3b"; };
    "nvim-FeMaco.lua" = { branch = "main"; commit = "96bbf843595dbe865838b3f2484b73557f34700c"; };
    "nvim-autopairs" = { branch = "master"; commit = "59bce2eef357189c3305e25bc6dd2d138c1683f5"; };
    "nvim-lspconfig" = { branch = "master"; commit = "ead0f5f342d8d323441e7d4b88f0fc436a81ad5f"; };
    "nvim-treesitter" = { branch = "master"; commit = "42fc28ba918343ebfd5565147a42a26580579482"; };
    "nvim-web-devicons" = { branch = "master"; commit = "737cf6c657898d0c697311d79d361288a1343d50"; };
    "oil.nvim" = { branch = "master"; commit = "0fcc83805ad11cf714a949c98c605ed717e0b83e"; };
    "plenary.nvim" = { branch = "master"; commit = "b9fd5226c2f76c951fc8ed5923d85e4de065e509"; };
    "rose-pine" = { branch = "main"; commit = "cf2a288696b03d0934da713d66c6d71557b5c997"; };
    "rustaceanvim" = { branch = "master"; commit = "88575b98bb9937fb9983ddec5e532b67e75ce677"; };
    "telekasten.nvim" = { branch = "main"; commit = "74b8644d1a9a4e63d033b1248cdcd11be0efb952"; };
    "telescope-media-files.nvim" = { branch = "master"; commit = "0826c7a730bc4d36068f7c85cf4c5b3fd9fb570a"; };
    "telescope.nvim" = { branch = "master"; commit = "5255aa27c422de944791318024167ad5d40aad20"; };
    "trouble.nvim" = { branch = "main"; commit = "bd67efe408d4816e25e8491cc5ad4088e708a69a"; };
    "undotree" = { branch = "main"; commit = "0e6d41d55ad147407e4ba00a292973de8db0b836"; };
    "which-key.nvim" = { branch = "main"; commit = "3aab2147e74890957785941f0c1ad87d0a44c15a"; };
  };

  xdg.configFile."nvim/lua/plugins/colors.lua".text = ''
    return {
    	"rose-pine/neovim",
    	name = "rose-pine",
    	config = function()
    		vim.cmd("colorscheme rose-pine-moon")
    	end
    }
  '';

  xdg.configFile."nvim/lua/plugins/dashboard.lua".text = ''
    return {
    	"nvim-mini/mini.starter",
    	config = function()
    		require("mini.starter").setup({
    			header = [[
    ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ██████╗ ██████╗ ██╗ ██████╗ ██████╗
    ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔══██╗██║██╔═████╗██╔══██╗
    ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝██████╔╝██████╔╝██║██║██╔██║██████╔╝
    ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██╔═══╝ ██╔══██╗██║████╔╝██║██╔══██╗
    ██║  ██║   ██║   ██║     ███████╗██║  ██║██║     ██║  ██║██║╚██████╔╝██║  ██║
    ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝
    				      ]],
    			footer = "we who cut mere stones must always be envisioning cathedrals",
    		})
    	end,
    }
  '';

  xdg.configFile."nvim/lua/plugins/fzf.lua".text = ''
    return {
    	"ibhagwan/fzf-lua",
    	dependencies = {
    		"nvim-mini/mini.icons",
    		"folke/which-key.nvim",
    	},
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
    			{ "<leader>f",         group = "find" },
    			{ "<leader>f<leader>", "<cmd>FzfLua<CR>",                 desc = "fzf menu" },
    			{ "<leader><leader>",  "<cmd>FzfLua buffers<CR>",         desc = "buffers" },
    			{ "<leader>fc",        "<cmd>FzfLua command_history<CR>", desc = "command history" },
    			{ "<leader>ff",        "<cmd>FzfLua files<CR>",           desc = "files" },
    			{ "<leader>fg",        "<cmd>FzfLua live_grep<CR>",       desc = "grep" },
    			{ "<leader>fk",        "<cmd>FzfLua keymaps<CR>",         desc = "keymaps" },
    			{ "<leader>fm",        "<cmd>FzfLua marks<CR>",           desc = "marks" },
    			{ "<leader>fr",        "<cmd>FzfLua registers<CR>",       desc = "registers" },
    		})
    	end,
    }
  '';

  xdg.configFile."nvim/lua/plugins/git.lua".text = ''
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
  '';

  xdg.configFile."nvim/lua/plugins/languages.lua".text = ''
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
    		config = function() --
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

    			vim.lsp.config["bashls"] = {
    				cmd = { "bash-language-server", "start" },
    			}

    			vim.lsp.config["dockerls"] = {
    				cmd = { "docker-langserver", "--stdio" },
    				filetypes = { "dockerfile" },
    				root_markers = { { "compose.yaml", "compose.yml", "Dockerfile" }, ".git" },
    			}

    			vim.lsp.config["docker_compose_language_service"] = {
    				cmd = { "docker-compose-language-server", "--stdio" },
    				filetypes = { "yaml" },
    				root_markers = { { "compose.yaml", "compose.yml", "Dockerfile" }, ".git" },
    			}

    			vim.lsp.config["lua_ls"] = {
    				cmd = { "lua-language-server" },
    				filetypes = { "lua" },
    				root_markers = { { ".luarc.json", ".luarc.jsonc", ".stylua.toml", ".luacheckrc" }, ".git" },
    			}

    			vim.lsp.config["markdown_oxide"] = {
    				cmd = { "oxi" },
    				filetypes = { "markdown" },
    				root_markers = { {}, ".git" },
    			}

    			vim.lsp.config["yamlls"] = {
    				cmd = { "yaml-language-server", "--stdio" },
    				filetypes = { "yaml" },
    				root_markers = { { ".yamllint", ".yamllint.yml", ".yamllint.yaml" }, ".git" },
    			}
    			vim.lsp.config["basedpyright"] = {
    				cmd = { "basedpyright-langserver", "--stdio" },
    				filetypes = { "python" },
    				root_markers = { { "pyproject.toml" }, ".git" },
    			}

    			vim.lsp.config["ruff"] = {
    				cmd = { "ruff", "server" },
    				filetypes = { "python" },
    				root_markers = { { "pyproject.toml" }, ".git" },
    			}

    			vim.api.nvim_create_autocmd("LspAttach", {
    				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    				callback = function(ev)
    					local opts = { buffer = ev.buf }
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
    	{
    		"AckslD/nvim-FeMaco.lua",
    		config = function()
    			require("femaco").setup({})
    			require("which-key").add({ "<leader>cb", "<cmd>FeMaco<cr>", desc = "code block editor" })
    		end,
    	},
    	{
    		"nvim-treesitter/nvim-treesitter",
    		build = ":TSUpdate",
    		main = "nvim-treesitter.configs",
    		opts = {
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
    		},
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
    	},
    }
  '';

  xdg.configFile."nvim/lua/plugins/lua.lua".text = ''
    return {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            { path = '${"$"}{3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      }
  '';

  xdg.configFile."nvim/lua/plugins/navigation.lua".text = ''
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
    }
  '';

  xdg.configFile."nvim/lua/plugins/notes.lua".text = ''
    return {
    	'renerocksai/telekasten.nvim',
    	dependencies = {
    		'nvim-telescope/telescope.nvim',
    		'nvim-telescope/telescope-media-files.nvim',
    		'folke/which-key.nvim',
    	},
    	config = function()
    		local notes_home = vim.fn.expand("~/wiki")

    		require('telekasten').setup({
    			home = notes_home,
    		})

    		local telescope = require("telescope")
    		telescope.setup({
    			extensions = {
    				media_files = {
    					filetypes = { "png", "jpg", "jpeg", "gif", "webp", "pdf" },
    					find_cmd = "rg",
    				},
    			},
    		})
    		telescope.load_extension("media_files")

    		local wk = require("which-key")

    		wk.add({
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

    			{ "<leader>nm", group = "media" },

    			{
    				"<leader>nmi",
    				function()
    					telescope.extensions.media_files.media_files({
    						cwd = notes_home,
    					})
    				end,
    				desc = "Browse images in notes",
    			},
    		})
    	end,
    }
  '';

  xdg.configFile."nvim/lua/plugins/rust.lua".text = ''
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
    		}
    	end,
    }
  '';

  xdg.configFile."nvim/lua/plugins/which-key.lua".text = ''
    local function toggle_zellij_menu()
    	if vim.env.ZELLIJ == nil or vim.env.ZELLIJ == "" then
    		vim.notify("Not running inside Zellij", vim.log.levels.WARN)
    		return
    	end

    	vim.fn.system({
    		"zellij",
    		"action",
    		"launch-or-focus-plugin",
    		"--floating",
    		"--move-to-focused-tab",
    		"zellij:session-manager",
    	})

    	if vim.v.shell_error ~= 0 then
    		vim.notify("Failed to open Zellij menu", vim.log.levels.ERROR)
    	end
    end

    local function rename_zellij_tab()
    	if vim.env.ZELLIJ == nil or vim.env.ZELLIJ == "" then
    		vim.notify("Not running inside Zellij", vim.log.levels.WARN)
    		return
    	end

    	local name = vim.fn.input("Rename tab to: ")
    	if name == nil or name == "" then
    		return
    	end

    	vim.fn.system({ "zellij", "action", "rename-tab", name })
    	if vim.v.shell_error ~= 0 then
    		vim.notify("Failed to rename Zellij tab", vim.log.levels.ERROR)
    	end
    end

    local function reload_zellij_config()
    	if vim.env.ZELLIJ == nil or vim.env.ZELLIJ == "" then
    		vim.notify("Not running inside Zellij", vim.log.levels.WARN)
    		return
    	end

    	local config_path = vim.fn.expand("~/.config/zellij/config.kdl")
    	vim.fn.system({ "touch", config_path })
    	if vim.v.shell_error ~= 0 then
    		vim.notify("Failed to reload Zellij config", vim.log.levels.ERROR)
    		return
    	end

    	vim.notify("Reloaded Zellij config")
    end

    return {
    	"folke/which-key.nvim",
    	event = "VeryLazy",
    	opts = {},
    	keys = {
    		{
    			"<leader>?",
    			function()
    				require("which-key").show({ global = false })
    			end,
    			desc = "Buffer Local Keymaps (which-key)",
    		},
    		{
    			"<leader>tt",
    			toggle_zellij_menu,
    			desc = "Toggle Zellij menu",
    		},
    		{
    			"<leader>r",
    			rename_zellij_tab,
    			desc = "Rename Zellij tab",
    		},
    		{
    			"<C-r>",
    			reload_zellij_config,
    			desc = "Reload Zellij config",
    		},
    	},
    }
  '';

  xdg.configFile."nvim/lua/themes/palette.lua".text = ''
    -- Theme: tokyonight
    -- Generated by theme-switch

    local M = {}

    M.name = "tokyonight"

    M.colors = {
        bg = "#24283b",
        bg_dark = "#1f2335",
        bg_light = "#3b4261",
        fg = "#c0caf5",
        fg_dark = "#a9b1d6",
        fg_muted = "#565f89",
        accent = "#7aa2f7",
        secondary = "#bb9af7",
        red = "#f7768e",
        orange = "#ff9e64",
        yellow = "#e0af68",
        green = "#9ece6a",
        cyan = "#7dcfff",
        blue = "#7aa2f7",
        magenta = "#bb9af7",
        border = "#3b4261",
        selection = "#33467c",
        cursor = "#c0caf5",
    }

    function M.apply()
        local c = M.colors

        vim.cmd("highlight clear")
        vim.o.background = "dark"
        vim.g.colors_name = "tokyonight"

        local highlights = {
            -- UI
            Normal = { fg = c.fg, bg = c.bg },
            NormalFloat = { fg = c.fg, bg = c.bg_dark },
            FloatBorder = { fg = c.border, bg = c.bg_dark },
            Cursor = { fg = c.bg, bg = c.cursor },
            CursorLine = { bg = c.bg_light },
            CursorLineNr = { fg = c.accent, bold = true },
            LineNr = { fg = c.fg_muted },
            SignColumn = { bg = c.bg },
            ColorColumn = { bg = c.bg_dark },
            Visual = { bg = c.selection },
            VisualNOS = { bg = c.selection },
            Search = { fg = c.bg, bg = c.yellow },
            IncSearch = { fg = c.bg, bg = c.orange },

            -- Popup menu
            Pmenu = { fg = c.fg, bg = c.bg_dark },
            PmenuSel = { fg = c.fg, bg = c.selection },
            PmenuSbar = { bg = c.bg_light },
            PmenuThumb = { bg = c.accent },

            -- Messages
            ErrorMsg = { fg = c.red },
            WarningMsg = { fg = c.yellow },
            MoreMsg = { fg = c.cyan },
            Question = { fg = c.cyan },

            -- Splits and tabs
            VertSplit = { fg = c.border },
            WinSeparator = { fg = c.border },
            TabLine = { fg = c.fg_muted, bg = c.bg_dark },
            TabLineSel = { fg = c.fg, bg = c.bg },
            TabLineFill = { bg = c.bg_dark },

            -- Statusline
            StatusLine = { fg = c.fg, bg = c.bg_dark },
            StatusLineNC = { fg = c.fg_muted, bg = c.bg_dark },

            -- Syntax
            Comment = { fg = c.fg_muted, italic = true },
            Constant = { fg = c.orange },
            String = { fg = c.green },
            Character = { fg = c.green },
            Number = { fg = c.orange },
            Boolean = { fg = c.orange },
            Float = { fg = c.orange },
            Identifier = { fg = c.fg },
            Function = { fg = c.blue },
            Statement = { fg = c.magenta },
            Conditional = { fg = c.magenta },
            Repeat = { fg = c.magenta },
            Label = { fg = c.cyan },
            Operator = { fg = c.fg_dark },
            Keyword = { fg = c.magenta },
            Exception = { fg = c.magenta },
            PreProc = { fg = c.cyan },
            Include = { fg = c.magenta },
            Define = { fg = c.magenta },
            Macro = { fg = c.cyan },
            PreCondit = { fg = c.cyan },
            Type = { fg = c.cyan },
            StorageClass = { fg = c.magenta },
            Structure = { fg = c.cyan },
            Typedef = { fg = c.cyan },
            Special = { fg = c.secondary },
            SpecialChar = { fg = c.secondary },
            Tag = { fg = c.accent },
            Delimiter = { fg = c.fg_dark },
            SpecialComment = { fg = c.fg_muted },
            Debug = { fg = c.red },
            Underlined = { underline = true },
            Error = { fg = c.red },
            Todo = { fg = c.bg, bg = c.yellow, bold = true },

            -- Diff
            DiffAdd = { bg = "#1a332a" },
            DiffChange = { bg = "#1a2a33" },
            DiffDelete = { bg = "#331a1a" },
            DiffText = { bg = "#1a3a4a" },

            -- Git signs
            GitSignsAdd = { fg = c.green },
            GitSignsChange = { fg = c.yellow },
            GitSignsDelete = { fg = c.red },

            -- Diagnostics
            DiagnosticError = { fg = c.red },
            DiagnosticWarn = { fg = c.yellow },
            DiagnosticInfo = { fg = c.cyan },
            DiagnosticHint = { fg = c.accent },
            DiagnosticUnderlineError = { undercurl = true, sp = c.red },
            DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow },
            DiagnosticUnderlineInfo = { undercurl = true, sp = c.cyan },
            DiagnosticUnderlineHint = { undercurl = true, sp = c.accent },

            -- Treesitter
            ["@variable"] = { fg = c.fg },
            ["@variable.builtin"] = { fg = c.red },
            ["@variable.parameter"] = { fg = c.fg },
            ["@constant"] = { fg = c.orange },
            ["@constant.builtin"] = { fg = c.orange },
            ["@module"] = { fg = c.cyan },
            ["@label"] = { fg = c.cyan },
            ["@string"] = { fg = c.green },
            ["@character"] = { fg = c.green },
            ["@number"] = { fg = c.orange },
            ["@boolean"] = { fg = c.orange },
            ["@type"] = { fg = c.cyan },
            ["@type.builtin"] = { fg = c.cyan },
            ["@attribute"] = { fg = c.cyan },
            ["@property"] = { fg = c.accent },
            ["@function"] = { fg = c.blue },
            ["@function.builtin"] = { fg = c.blue },
            ["@function.method"] = { fg = c.blue },
            ["@constructor"] = { fg = c.cyan },
            ["@keyword"] = { fg = c.magenta },
            ["@keyword.function"] = { fg = c.magenta },
            ["@keyword.return"] = { fg = c.magenta },
            ["@keyword.operator"] = { fg = c.magenta },
            ["@keyword.import"] = { fg = c.magenta },
            ["@keyword.conditional"] = { fg = c.magenta },
            ["@keyword.repeat"] = { fg = c.magenta },
            ["@operator"] = { fg = c.fg_dark },
            ["@punctuation"] = { fg = c.fg_dark },
            ["@punctuation.bracket"] = { fg = c.fg_dark },
            ["@punctuation.delimiter"] = { fg = c.fg_dark },
            ["@comment"] = { fg = c.fg_muted, italic = true },
            ["@tag"] = { fg = c.accent },
            ["@tag.attribute"] = { fg = c.secondary },
            ["@tag.delimiter"] = { fg = c.fg_dark },
        }

        for group, opts in pairs(highlights) do
            vim.api.nvim_set_hl(0, group, opts)
        end
    end

    return M
  '';
}
