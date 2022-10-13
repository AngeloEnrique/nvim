local status, packer = pcall(require, 'packer')
if (not status) then
  print("Packer is not installed")
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'themercorp/themer.lua'
  use 'kyazdani42/nvim-web-devicons' -- File icons


  use 'nvim-lualine/lualine.nvim' -- Statusline
  use 'WhoIsSethDaniel/lualine-lsp-progress.nvim' -- LSP progress for lualine
  use 'onsails/lspkind-nvim' -- vscode-like pictograms

  use 'neovim/nvim-lspconfig' -- LSP
  use 'glepnir/lspsaga.nvim' -- LSP UIs

  use {
    'rafamadriz/friendly-snippets',
    module = { "cmp", "cmp_nvim_lsp" },
    event = "InsertEnter",
  }
  use {
    'L3MON4D3/LuaSnip', -- Snippets
    wants = "friendly-snippets",
    after = 'nvim-cmp',
    config = function() require('config.snippets') end,
  }
  use "saadparwaiz1/cmp_luasnip" --cmp luasnip
  use 'hrsh7th/cmp-path' -- nvim-cmp buffer for paths
  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-nvim-lsp' -- nvim-cmp source for neovim's built-in LSP
  use 'hrsh7th/cmp-nvim-lua' -- nvim-cmp for luasnip
  use 'hrsh7th/nvim-cmp' -- Completion
  use 'github/copilot.vim' -- Github Copilot

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'jose-elias-alvarez/null-ls.nvim' -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
  use 'MunifTanjim/prettier.nvim' -- Prettier plugin for Neovim's built-in LSP client.
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'

  use 'nvim-lua/plenary.nvim' -- Common utilities
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'

  use 'akinsho/nvim-bufferline.lua'
  use 'SmiteshP/nvim-navic' -- Breadcrumb
  use 'norcalli/nvim-colorizer.lua'
  use 'numToStr/Comment.nvim' -- For comments
  use 'lukas-reineke/indent-blankline.nvim'

  use 'lewis6991/gitsigns.nvim'
  use 'dinhhuy258/git.nvim' -- For git blame and browse
end)
