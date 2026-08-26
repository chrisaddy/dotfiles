local map = vim.keymap.set

map("n", "<leader>cc", "<CMD>ClaudeCode<CR>", { desc = "toggle [c]laude" })
map("n", "<leader>cf", "<CMD>ClaudeCodeFocus<CR>", { desc = "[f]ocus claude" })
map("n", "<leader>cb", "<CMD>ClaudeCodeAdd %<CR>", { desc = "add [b]uffer to context" })
-- Visual-mode send is the point of the WebSocket bridge: the selection
-- arrives as an @-mention rather than pasted text.
map("v", "<leader>cs", "<CMD>ClaudeCodeSend<CR>", { desc = "[s]end selection to claude" })
map("n", "<leader>cy", "<CMD>ClaudeCodeDiffAccept<CR>", { desc = "accept diff ([y]es)" })
map("n", "<leader>cn", "<CMD>ClaudeCodeDiffDeny<CR>", { desc = "deny diff ([n]o)" })

map("n", "<leader>o", "<CMD>Oil<CR>", { desc = "[o]pen parent directory" })

map("n", "<leader>fdb", "<CMD>FzfLua diagnostics_document<CR>", { desc = "[b]uffer" })
map("n", "<leader>fdq", "<CMD>FzfLua quickfix<CR>", { desc = "[q]uickfix" })
map("n", "<leader>fdw", "<CMD>FzfLua diagnostics_workspace<CR>", { desc = "[w]orkspace" })
map("n", "<leader>ff", "<CMD>FzfLua files<CR>", { desc = "[f]iles" })
map("n", "<leader>fm", "<CMD>FzfLua marks<CR>", { desc = "[m]arks" })
map("n", "<leader>fM", "<CMD>FzfLua<CR>", { desc = "[M]enu" })
map("n", "<leader>fr<CR>", "<CMD>FzfLua registers", { desc = "[r]egisters" })

map("n", "<leader>gb", "<CMD>FzfLua git_branches<CR>", { desc = "[b]ranches" })
map("n", "<leader>gB", "<CMD>FzfLua git_blame<CR>", { desc = "[B]lame" })
map("n", "<leader>gc", "<CMD>FzfLua git_commits", { desc = "[c]ommits" })
map("n", "<leader>gd", "<CMD>CodeDiff<CR>", { desc = "[d]iff" })
map("n", "<leader>gg", "<CMD>LazyGit<CR>", { desc = "Lazy [g]it" })
map("n", "<leader>gh", "<CMD>FzfLua git_hunks<CR>", { desc = "[h]unks" })
map("n", "<leader>gs", "<CMD>FzfLua git_status<CR>", { desc = "[s]tatus" })
map("n", "<leader>gw", "<CMD>FzfLua git_worktrees<CR>", { desc = "[w]orktrees" })

-- harpoon2 exposes `list` and `ui` as objects with colon-methods, so these
-- have to be raw lua closures — there is no `:Harpoon` command, and a
-- dot-call like `harpoon.ui.toggle_quick_menu()` passes no `self`.
map("n", "<leader>ha", function() require("harpoon"):list():add() end, { desc = "[a]dd file" })
map("n", "<leader>hh", function()
  local harpoon = require("harpoon")
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "toggle quick menu" })
map("n", "<leader>hn", function() require("harpoon"):list():next() end, { desc = "[n]ext mark" })
map("n", "<leader>hp", function() require("harpoon"):list():prev() end, { desc = "[p]revious mark" })
map("n", "<leader>h1", function() require("harpoon"):list():select(1) end, { desc = "mark 1" })
map("n", "<leader>h2", function() require("harpoon"):list():select(2) end, { desc = "mark 2" })
map("n", "<leader>h3", function() require("harpoon"):list():select(3) end, { desc = "mark 3" })
map("n", "<leader>h4", function() require("harpoon"):list():select(4) end, { desc = "mark 4" })

map("n", "<leader>u", "<CMD>FzfLua undotree<CR>", { desc = "[u]ndotree" })
map("n", "<leader>w", "<CMD>w<CR>", { desc = "[w]rite File" })
