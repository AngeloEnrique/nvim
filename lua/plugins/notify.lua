return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require "notify"
    notify.setup {
      stages = "fade_in_slide_out",
      render = "compact",
      background_colour = "#000000",
    }
    vim.notify = notify
  end,
}
