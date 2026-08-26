return {
  -- blink.pairs v0.6+ factored its core matching engine out into a separate
  -- dependency (blink.lib) and now needs its native library built explicitly
  -- rather than fetched implicitly on first use.
  {
    "saghen/blink.pairs",
    dependencies = { "saghen/blink.lib" },
    build = function()
      require("blink.pairs").build():pwait(60000)
    end,
    opts = {},
  },

  { "Kaiser-Yang/blink-cmp-avante", lazy = true },

  -- Inline (ghost text) completion, the half of Cody that claudecode does not
  -- cover. The free tier needs a one-off `:SupermavenUseFree`; no credential
  -- is stored in this repo.

  {
    "saghen/blink.cmp",
    dependencies = { "Kaiser-Yang/blink-cmp-avante" },
    version = "*",
    opts = {
      -- Supermaven owns <Tab>. blink applies its keymaps buffer-locally on
      -- InsertEnter, which beats supermaven's global insert-mode map, so the
      -- preset's `snippet_forward` would otherwise get first refusal on every
      -- Tab. Leaving only `fallback` here makes blink hand the key straight to
      -- supermaven; snippet_forward moves to <C-l>, and <S-Tab> keeps the
      -- preset's snippet_backward (supermaven does not map it).
      --
      -- This also has to be a real handoff rather than relying on
      -- supermaven's own fallback: when it has no suggestion it feedkeys a
      -- noremap <Tab>, which inserts a literal tab and never reaches blink.
      keymap = {
        preset = "default",
        ["<Tab>"] = { "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "buffer", "avante" },
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
          },
        },
      },
    },
  },
}
