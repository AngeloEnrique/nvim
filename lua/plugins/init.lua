return {
  {
    "nvim-tree/nvim-web-devicons",
    event = "BufRead",
    opts = {
      override = {},
      default = true,
    },
  }, -- File icons
  { "mbbill/undotree",   keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>" } } },
  {
    "tpope/vim-dispatch",
    cmd = { "Make", "Dispatch" },
  },
  { "tpope/vim-repeat",  event = "BufRead" },
  { "tpope/vim-rhubarb", event = "BufRead" },
  { "tpope/vim-dotenv",  event = "BufRead" },
  { "tpope/vim-eunuch",  event = "BufRead" },
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      local nvim_tmux_nav = require "nvim-tmux-navigation"

      nvim_tmux_nav.setup {
        disable_when_zoomed = true, -- defaults to false
      }

      vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },

  { 'kevinhwang91/nvim-bqf' },
  {
    "axelvc/template-string.nvim",
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact", "python" },
    opts = {
      filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "python" }, -- filetypes where the plugin is active
      jsx_brackets = true,                                                                        -- must add brackets to jsx attributes
      remove_template_string = false,                                                             -- remove backticks when there are no template string
      restore_quotes = {
        -- quotes used when "remove_template_string" option is enabled
        normal = [[']],
        jsx = [["]],
      },
    },
  },
  { "folke/todo-comments.nvim", event = "BufRead", dependencies = "nvim-lua/plenary.nvim", config = true },
  { "mg979/vim-visual-multi",   event = "BufRead" },
  {
    "rmagatti/alternate-toggler",
    keys = "<leader>ta",
    config = function()
      vim.keymap.set("n", "<leader>ta", "<cmd>ToggleAlternate<cr>")
    end,
  },
  {
    "folke/neodev.nvim",
    event = "BufRead",
  },

  { "SmiteshP/nvim-navic", lazy = true }, -- Breadcrumb
}
