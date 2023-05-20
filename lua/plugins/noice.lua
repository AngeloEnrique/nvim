return {
  "folke/noice.nvim",
  enabled = true,
  event = "UIEnter",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      config = function()
        local notify = require "notify"
        notify.setup {
          stages = "fade_in_slide_out",
          render = "compact",
        }
      end,
    },
  },
  config = function()
    require("noice").setup {
      cmdline = { view = "cmdline" },
      popupmenu = { enabled = false },
      lsp = {
        progress = { enabled = true },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        long_message_to_split = true,
        lsp_doc_border = false,
      },
      throttle = 42,
      views = {
        split = {
          enter = true,
          size = "25%",
          win_options = { signcolumn = "no", number = false, relativenumber = false, list = false, wrap = false },
        },
        popup = {
          border = "none",
        },
        hover = {
          border = "none",
          position = { row = 2, col = 2 },
        },
        mini = {
          timeout = 3000,
          position = { row = -2 },
          border = "none",
          win_options = { winblend = 10 },
        },
        cmdline_popup = {
          border = "none",
        },
        confirm = {
          border = "none",
        },
        cmdline = {
          win_options = { winblend = 10 },
        },
      },
    }
  end,
}
