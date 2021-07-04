" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/addy/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/addy/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/addy/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/addy/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/addy/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["auto-session"] = {
    config = { "\27LJ\2\nF\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\30addy.plugins.auto_session\frequire\0" },
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/auto-session"
  },
  black = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\23addy.plugins.black\frequire\0" },
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/black"
  },
  fzf = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/fzf.vim"
  },
  ["git-messenger.vim"] = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/git-messenger.vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\26addy.plugins.gitsigns\frequire\0" },
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  ["lsp_extensions.nvim"] = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/lsp_extensions.nvim"
  },
  ["lspcontainers.nvim"] = {
    config = { "\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\21addy.plugins.lsp\frequire\0" },
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/lspcontainers.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\25addy.plugins.lualine\frequire\0" },
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  nerdcommenter = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/nerdcommenter"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nD\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\28addy.plugins.treesitter\frequire\0" },
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["session-lens"] = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/session-lens"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\nC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\27addy.plugins.telescope\frequire\0" },
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    config = { "\27LJ\2\nD\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\28addy.plugins.tokyonight\frequire\0" },
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/tokyonight.nvim"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-floaterm"] = {
    config = { "\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\26addy.plugins.floaterm\frequire\0" },
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/vim-floaterm"
  },
  ["vim-zettel"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\24addy.plugins.zettel\frequire\0" },
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/vim-zettel"
  },
  vimwiki = {
    loaded = true,
    path = "/Users/addy/.local/share/nvim/site/pack/packer/start/vimwiki"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: lspcontainers.nvim
time([[Config for lspcontainers.nvim]], true)
try_loadstring("\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\21addy.plugins.lsp\frequire\0", "config", "lspcontainers.nvim")
time([[Config for lspcontainers.nvim]], false)
-- Config for: black
time([[Config for black]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\23addy.plugins.black\frequire\0", "config", "black")
time([[Config for black]], false)
-- Config for: vim-zettel
time([[Config for vim-zettel]], true)
try_loadstring("\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\24addy.plugins.zettel\frequire\0", "config", "vim-zettel")
time([[Config for vim-zettel]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\nC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\27addy.plugins.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nD\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\28addy.plugins.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: tokyonight.nvim
time([[Config for tokyonight.nvim]], true)
try_loadstring("\27LJ\2\nD\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\28addy.plugins.tokyonight\frequire\0", "config", "tokyonight.nvim")
time([[Config for tokyonight.nvim]], false)
-- Config for: vim-floaterm
time([[Config for vim-floaterm]], true)
try_loadstring("\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\26addy.plugins.floaterm\frequire\0", "config", "vim-floaterm")
time([[Config for vim-floaterm]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\26addy.plugins.gitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\25addy.plugins.lualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: auto-session
time([[Config for auto-session]], true)
try_loadstring("\27LJ\2\nF\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\30addy.plugins.auto_session\frequire\0", "config", "auto-session")
time([[Config for auto-session]], false)
if should_profile then save_profiles() end

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
