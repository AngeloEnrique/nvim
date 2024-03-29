return {
  "Wansmer/treesj",
  keys = { "<leader>m", "<leader>M" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local treesj = require "treesj"
    treesj.setup {
      -- Use default keymaps
      -- (<space>m - toggle, <space>j - join, <space>s - split)
      use_default_keymaps = false,

      -- Node with syntax error will not be formatted
      check_syntax_error = true,

      -- If line after join will be longer than max value,
      -- node will not be formatted
      max_join_length = 120,

      -- hold|start|end:
      -- hold - cursor follows the node/place on which it was called
      -- start - cursor jumps to the first symbol of the node being formatted
      -- end - cursor jumps to the last symbol of the node being formatted
      cursor_behavior = "hold",

      -- Notify about possible problems or not
      notify = true,

      -- Use `dot` for repeat action
      dot_repeat = true,
    }
    -- For use default preset and it work with dot
    vim.keymap.set("n", "<leader>m", treesj.toggle)
    -- For extending default preset with `recursive = true`, but this doesn't work with dot
    vim.keymap.set("n", "<leader>M", function()
      treesj.toggle { split = { recursive = true } }
    end)
  end,
}
