return {
  "rebelot/heirline.nvim",
  event = "UIEnter",
  dependencies = {
    { "lewis6991/gitsigns.nvim", config = true },
  },
  config = function()
    local StatusLines = require("sixzen.heirline.statusline").StatusLines

    require("heirline").setup {
      statusline = StatusLines,
    }
  end,
}
