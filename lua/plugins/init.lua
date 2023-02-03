return {
  { 'folke/tokyonight.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
  { 'kyazdani42/nvim-web-devicons',
    config = {

      override = {},
      default = true,
    }
  }, -- File icons
  { 'j-hui/fidget.nvim',
    config = true },
  -- { 'WhoIsSethDaniel/lualine-lsp-progress.nvim',
  --   dependencies = {
  --     'nvim-lualine/lualine.nvim', -- Statusline
  --   }
  -- }, -- LSP progress for lualine

  'neovim/nvim-lspconfig', -- LSP
  'mfussenegger/nvim-jdtls', -- Java stuffs


  {
    'rafamadriz/friendly-snippets',
    module = { "cmp", "cmp_nvim_lsp" },
    event = "InsertEnter",
    dependencies = {
      'L3MON4D3/LuaSnip', -- Snippets
    }
  },
  { 'saadparwaiz1/cmp_luasnip',
    dependencies = {
      'hrsh7th/nvim-cmp',
    }
  }, --cmp luasnip
  { 'hrsh7th/cmp-path',
    dependencies = {
      'hrsh7th/nvim-cmp',
    }
  }, -- nvim-cmp buffer for paths
  { 'hrsh7th/cmp-buffer',
    dependencies = {
      'hrsh7th/nvim-cmp',
    }
  }, -- nvim-cmp source for buffer words
  { 'hrsh7th/cmp-nvim-lsp',
    dependencies = {
      'hrsh7th/nvim-cmp',
    }
  }, -- nvim-cmp source for neovim',s built-in LSP
  { 'hrsh7th/cmp-nvim-lua',
    dependencies = {
      'hrsh7th/nvim-cmp',
    }
  }, -- nvim-cmp for luasnip
  'github/copilot.vim', -- Github Copilot

  { 'MunifTanjim/prettier.nvim',
    config = {
      bin = 'prettierd',
      filetypes = {
        'css',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'json',
        'scss',
        'less',
        'python'
      }
    }
  }, -- Prettier plugin for Neovim',s built-in LSP client.
  'williamboman/mason.nvim',
  { 'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    config = function()
      local mason = require 'mason'
      local lspconfig = require 'mason-lspconfig'

      mason.setup {}
      lspconfig.setup {
        ensure_installed = {
        }
      }
    end
  },

  { 'windwp/nvim-autopairs',
    config = {
      disable_filetype = { 'TelescopePrompt', 'vim' }
    }
  },
  { 'windwp/nvim-ts-autotag',
    config = true
  },

  'nvim-lua/plenary.nvim', -- Common utilities
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },

  'SmiteshP/nvim-navic', -- Breadcrumb
  { 'norcalli/nvim-colorizer.lua',
    config = {
      '*';
    }
  },
  { 'numToStr/Comment.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'JoosepAlviste/nvim-ts-context-commentstring', -- Comments for jsx
    },
    config = function()
      local comment = require 'Comment'
      local pre_hook
      local ts_comment = require "ts_context_commentstring.integrations.comment_nvim"
      pre_hook = ts_comment.create_pre_hook()

      comment.setup {
        pre_hook = pre_hook,
      }
    end,

  }, -- For comments
  { 'lukas-reineke/indent-blankline.nvim',
    config = {
      buftype_exclude = { "terminal" },
      show_trailing_blankline_indent = false,
      show_first_indent_level = false,
      show_current_context = true,
      show_current_context_start = true,
    }
  },
  { 'akinsho/toggleterm.nvim',
    config = {
      -- size can be a number or function which is passed the current terminal
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      persist_size = false,
      -- direction = 'vertical' | 'horizontal' | 'window' | 'float',
      direction = "float",
      close_on_exit = true, -- close the terminal window when the process exits
      shell = vim.o.shell, -- change the default shell
      -- This field is only relevant if direction is set to 'float'
      float_opts = {
        -- The border key is *almost* the same as 'nvim_win_open'
        -- see :h nvim_win_open for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        border = "curved",
        -- width = <value>,
        -- height = <value>,
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        }
      }
    }
  },

  { 'lewis6991/gitsigns.nvim',
    config = {
      current_line_blame = true
    }
  },
  { 'dinhhuy258/git.nvim',
    config = {
      keymaps = {
        -- Open blame window
        blame = '<Leader>gb',
        -- Open file/folder in git repository
        browse = '<Leader>go'
      }
    }
  }, -- For git blame and browse
}
