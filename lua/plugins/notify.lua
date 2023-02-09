return {
	"rcarriga/nvim-notify",
	config = function()
		local notify = require("notify")
		notify.setup({
			stages = "slide",
			render = "compact",
		})
		vim.notify = notify
	end,
}
