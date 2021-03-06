local cmd = vim.api.nvim_command
local fn = vim.fn
local packer = nil

local function packer_verify()
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
    cmd 'packadd packer.nvim'
  end
end

local function packer_startup()
  if packer == nil then
    packer = require'packer'
    packer.init()
  end

  local use = packer.use
  packer.reset()

  -- Packer
  use 'wbthomason/packer.nvim'

  -- Language Servers
  use {
    'lspcontainers/lspcontainers.nvim',
    requires = {
      'neovim/nvim-lspconfig',
      'nvim-lua/lsp_extensions.nvim',
    },
    config = function ()
      require'addy.plugins.lsp'.init()
    end
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = 'TSUpdate',
    config = function ()
      require'addy.plugins.treesitter'.init()
    end,
  }

  -- Completion
--  use {
--    'hrsh7th/nvim-compe',
--    requires = {
--      {
--        'erkrnt/compe-tabnine',
--        run = './install.sh'
--      },
--      'wellle/tmux-complete.vim',
--      'hrsh7th/vim-vsnip',
--      'onsails/lspkind-nvim'
--    },
--    config = function ()
--       require'addy.plugins.compe'.init()
--      require'addy.plugins.compe_tabnine'.init()
--      require'addy.plugins.lspkind'.init()
--    end
--  }

  -- Telescope
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = 'rmagatti/session-lens',
    config = function ()
      require'addy.plugins.telescope'.init()
    end
  }

  -- Themes
  use {
    'folke/tokyonight.nvim',
    config = function ()
      require 'addy.plugins.tokyonight'.init()
    end
  }

  -- Git Support
  use 'rhysd/git-messenger.vim'
  use {
    'lewis6991/gitsigns.nvim',
    config = function ()
      require'addy.plugins.gitsigns'.init()
    end
  }

  -- Sessions
  use {
    'rmagatti/auto-session',
    config = function ()
      require'addy.plugins.auto_session'.init()
    end
  }

  -- Utilities
  use {
    'lukas-reineke/indent-blankline.nvim',
    branch = 'lua'
  }
  use {
    'hoob3rt/lualine.nvim',
    config = function ()
      require 'addy.plugins.lualine'.init()
    end
  }
  use 'preservim/nerdcommenter'
  use 'romgrk/nvim-treesitter-context'
  use 'kyazdani42/nvim-web-devicons'
  use {
    'voldikss/vim-floaterm',
    config = function ()
      require 'addy.plugins.floaterm'.init()
    end
  }

  use {
    'tpope/vim-commentary',
    -- config = function ()
    --   require 'addy.plugins.vim_commentary'.init()
    -- end
  }

  use {
    'psf/black',
    config = function()
      require 'addy.plugins.black'.init()
    end
  }

  -- VimWiki + Zettelkasten
  use {
    'michal-h21/vim-zettel',
    requires = {
      {
        'junegunn/fzf',
        run = function () vim.fn['fzf#install']() end
      },
      'junegunn/fzf.vim',
      'vimwiki/vimwiki'
    },
    config = function ()
      require'addy.plugins.zettel'.init()
    end
  }
end

local function init()
  packer_verify()
  packer_startup()
end

return {
  init = init
}
