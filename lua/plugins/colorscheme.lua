return {
  {
    "folke/tokyonight.nvim",
    enabled = false,
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      require("tokyonight").setup {
        style = "night",
        styles = {
          sidebars = "dark",
          floats = "transparent",
        },
      }
      vim.cmd.colorscheme "tokyonight"
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("catppuccin").setup {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
          -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false, -- show the '~' characters after the end of buffers
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        -- no_italic = false, -- Force no italic
        -- no_bold = false,   -- Force no bold
        -- styles = {
        --   comments = { "italic" },
        --   conditionals = { "italic" },
        --   loops = {},
        --   functions = {},
        --   keywords = {},
        --   strings = {},
        --   variables = {},
        --   numbers = {},
        --   booleans = {},
        --   properties = {},
        --   types = {},
        --   operators = {},
        -- },
        -- color_overrides = {},
        custom_highlights = function(colors)
          return {
            StatusLine = { bg = colors.none },
            TabLineFill = { bg = colors.none },
            TreesitterContextBottom = {
              sp = colors.surface0,
              style = {},
            },
            PackageInfoOutdatedVersion = { fg = colors.peach },
            CmpNormal = { bg = colors.mantle },
            LspInlayHint = { fg = colors.surface1, bg = colors.none },
            -- InclineNormal = { bg = colors.mantle },
            -- InclineNormalNC = { bg = colors.surface0 },
          }
        end,
        integrations = {
          cmp = true,
          gitsigns = true,
          telescope = { enabled = true, style = "nvchad" },
          notify = true,
          illuminate = true,
          -- navic = { enabled = true },
          treesitter = true,
          treesitter_context = true,
          neogit = true,
          neotree = true,
          mason = true,
          lsp_trouble = true,
          dashboard = true,
          render_markdown = true,
          window_picker = true,
          -- alpha = true,
          noice = true,
          -- lsp_saga = true,
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      }

      -- setup must be called before loading
      vim.cmd.colorscheme "catppuccin"
    end,
  },
}
