return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "numToStr/Comment.nvim",
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- {
    --   "windwp/nvim-autopairs",
    --   opts = {
    --     disable_filetype = { "TelescopePrompt", "vim" },
    --   },
    -- },
    {
      "nvim-treesitter/nvim-treesitter-context",
      config = function()
        require("treesitter-context").setup {
          enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
          max_lines = 6,            -- How many lines the window should span. Values <= 0 mean no limit.
          min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
          line_numbers = true,
          multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
          trim_scope = "outer",     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
          mode = "cursor",          -- Line used to calculate context. Choices: 'cursor', 'topline'
          -- Separator between context and content. Should be a single character string, like '-'.
          -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
          separator = nil,
          zindex = 20, -- The Z-index of the context window
        }
        -- vim.api.nvim_set_hl(0, "TreesitterContext", { link = "StatusLine" })
      end,
    },
  },
  main = "nvim-treesitter.configs",
  opts = {
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
      "go",
      "rust",
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
      end,
    },
    indent = {
      enable = true,
      disable = function()
        return vim.b.large_buf
      end,
    },
    -- autotag = {
    --   enable = true,
    -- },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
          ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
          ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
          ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

          ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
          ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

          ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
          ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

          ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
          ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

          ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
          ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

          ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
          ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

          ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
          ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = { query = "@call.outer", desc = "Next function call start" },
            ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
            ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
            ["]l"] = { query = "@loop.outer", desc = "Next loop start" },

            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next_end = {
            ["]F"] = { query = "@call.outer", desc = "Next function call end" },
            ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
            ["]C"] = { query = "@class.outer", desc = "Next class end" },
            ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
            ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
            ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
            ["[c"] = { query = "@class.outer", desc = "Prev class start" },
            ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
            ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
          },
          goto_previous_end = {
            ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
            ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
            ["[C"] = { query = "@class.outer", desc = "Prev class end" },
            ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
            ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
          },
        },
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-Space>", -- set to `false` to disable one of the mappings
        node_incremental = "<C-Space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },
}
