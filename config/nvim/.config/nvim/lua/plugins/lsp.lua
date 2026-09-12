return {
  { "lukas-reineke/lsp-format.nvim", opts = {} },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "lukas-reineke/lsp-format.nvim" },
    config = function()
      local lsp_format = require("lsp-format")
      lsp_format.setup({})

      -- No mason.nvim here: every server below is expected on $PATH, installed
      -- through pacman/paru/npm/pip per the Justfile's package list rather than
      -- through a second, nvim-managed package manager.
      local servers = {
        "basedpyright",
        "bashls",
        "docker_compose_language_service",
        "dockerls",
        "ghcide",
        "helm_ls",
        "html",
        "htmx",
        "just",
        "lua_ls",
        "markdown_oxide",
        "nixd",
        "nushell",
        "ocamllsp",
        "postgres_lsp",
        "ruff",
        "rust_analyzer",
        "sqls",
        "sqruff",
        "ty",
        "yamlls",
      }

      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          on_attach = lsp_format.on_attach,
        })
      end
      vim.lsp.enable(servers)
    end,
  },
}
