return {
  "rebelot/heirline.nvim",
  event = "UIEnter",
  dependencies = {
    { "lewis6991/gitsigns.nvim", config = true },
  },
  config = function()
    local StatusLines = require("sixzen.heirline.statusline").StatusLines
    local TabLine = require("sixzen.heirline.tabline").TabLine

    require("heirline").setup {
      statusline = StatusLines,
      tabline = TabLine
    }
  end,
}
