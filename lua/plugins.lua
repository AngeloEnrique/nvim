local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'folke/tokyonight.nvim',
  'kyazdani42/nvim-web-devicons', -- File icons

  'nvim-lualine/lualine.nvim', -- Statusline
  'WhoIsSethDaniel/lualine-lsp-progress.nvim', -- LSP progress for lualine
  'onsails/lspkind-nvim', -- vscode-like pictograms

  'neovim/nvim-lspconfig', -- LSP
  'glepnir/lspsaga.nvim', -- LSP UIs
  'mfussenegger/nvim-jdtls', -- Java stuffs

  -- 'mfussenegger/nvim-dap', -- Debugger
  -- 'rcarriga/nvim-dap-ui', -- Debugger UIs

  {
    'rafamadriz/friendly-snippets',
    module = { "cmp", "cmp_nvim_lsp" },
    event = "InsertEnter",
    dependencies = {
      'L3MON4D3/LuaSnip', -- Snippets
    }
  },
  {
    'L3MON4D3/LuaSnip', -- Snippets
    config = function() require('config.snippets') end,
  },
  'saadparwaiz1/cmp_luasnip', --cmp luasnip
  'hrsh7th/cmp-path', -- nvim-cmp buffer for paths
  'hrsh7th/cmp-buffer', -- nvim-cmp source for buffer words
  'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for neovim',s built-in LSP
  'hrsh7th/cmp-nvim-lua', -- nvim-cmp for luasnip
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip', -- Snippets
    }
  }, -- Completion
  'github/copilot.vim', -- Github Copilot

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate'
  },
  'jose-elias-alvarez/null-ls.nvim', -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
  'MunifTanjim/prettier.nvim', -- Prettier plugin for Neovim',s built-in LSP client.
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  'windwp/nvim-autopairs',
  'windwp/nvim-ts-autotag',

  'nvim-tree/nvim-tree.lua',
  'nvim-lua/plenary.nvim', -- Common utilities
  'nvim-telescope/telescope.nvim',
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },

  { 'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async' },
  'akinsho/nvim-bufferline.lua',
  'SmiteshP/nvim-navic', -- Breadcrumb
  'norcalli/nvim-colorizer.lua',
  'numToStr/Comment.nvim', -- For comments
  'JoosepAlviste/nvim-ts-context-commentstring', -- Comments for jsx
  'lukas-reineke/indent-blankline.nvim',
  'RRethy/vim-illuminate', -- Highlight all occurrences of the word under the cursor
  "akinsho/toggleterm.nvim",

  { 'NTBBloodbath/rest.nvim',
    dependencies = { "nvim-lua/plenary.nvim" } },

  'lewis6991/gitsigns.nvim',
  'dinhhuy258/git.nvim', -- For git blame and browse
})
