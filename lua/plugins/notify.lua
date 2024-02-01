return {
  "rcarriga/nvim-notify",
  event = "UIEnter",
  enabled = true,
  config = function()
    local notify = require "notify"
    notify.setup {
      stages = "fade_in_slide_out",
      render = "compact",
    }
    vim.notify = notify
  end,
}
