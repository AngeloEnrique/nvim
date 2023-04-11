return {
  "nvim-treesitter/nvim-treesitter",
  event = "BufRead",
  build = ":TSUpdate",
  dependencies = {
    "numToStr/Comment.nvim",
    "JoosepAlviste/nvim-ts-context-commentstring", -- Comments for jsx
    -- "HiPhish/nvim-ts-rainbow2",
    {
      "windwp/nvim-autopairs",
      opts = {
        disable_filetype = { "TelescopePrompt", "vim" },
      },
    },
    { "windwp/nvim-ts-autotag", config = true },
    {
      "nvim-treesitter/nvim-treesitter-context",
      config = function()
        require("treesitter-context").setup {
          enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
          max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
          min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
          line_numbers = true,
          multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
          trim_scope = "outer",     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
          mode = "topline",         -- Line used to calculate context. Choices: 'cursor', 'topline'
          -- Separator between context and content. Should be a single character string, like '-'.
          -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
          separator = nil,
          zindex = 20, -- The Z-index of the context window
        }
        vim.api.nvim_set_hl(0, "TreesitterContext", { link = "StatusLine" })
      end,
    },
  },
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = {
        "tsx",
        "lua",
        "json",
        "javascript",
        "typescript",
        "html",
        "css",
        "python",
        "http",
        "bash",
        "vimdoc",
        "yaml",
        "toml",
        "go",
        "rust",
        "c",
        "cpp",
        "java",
        "markdown",
        "markdown_inline",
        "regex",
        "vim",
      },
      sync_install = true,
      auto_install = true,
      highlight = {
        enable = true,
        aditional_vim_regex_highlighting = false,
        disable = function()
          return vim.b.large_buf
        end
      },
      indent = {
        enable = true,
        disable = function()
          return vim.b.large_buf
        end
      },
      autotag = {
        enable = true,
      },
      -- rainbow = {
      --   enable = false,
      --   disable = {},
      --   query = {
      --     "rainbow-parens",
      --     html = "rainbow-tags",
      --     tsx = {
      --       "rainbow-tags",
      --     },
      --     javascript = {
      --       "rainbow-parens-react",
      --       "rainbow-tags-react",
      --     },
      --   },
      --   strategy = require("ts-rainbow").strategy.global,
      -- },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn", -- set to `false` to disable one of the mappings
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    }
  end,
}
