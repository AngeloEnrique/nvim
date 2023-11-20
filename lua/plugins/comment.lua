return {
  "numToStr/Comment.nvim",
  event = "BufRead",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring", -- Comments for jsx
  },
  config = function()
    vim.g.skip_ts_context_commentstring_module = true
    require("ts_context_commentstring").setup {
      enable_autocmd = false,
    }

    local comment = require "Comment"

    comment.setup {
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    }
  end,
} -- For comments
