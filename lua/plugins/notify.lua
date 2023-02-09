return {
	"rcarriga/nvim-notify",
	config = function()
		local notify = require("notify")
		notify.setup({
			stages = "slide",
			render = "compact",
			background_colour = "#000000",
		})
		vim.notify = notify
	end,
}
