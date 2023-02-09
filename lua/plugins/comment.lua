return {
	"numToStr/Comment.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"JoosepAlviste/nvim-ts-context-commentstring", -- Comments for jsx
	},
	config = function()
		local comment = require("Comment")
		local pre_hook
		local ts_comment = require("ts_context_commentstring.integrations.comment_nvim")
		pre_hook = ts_comment.create_pre_hook()

		comment.setup({
			pre_hook = pre_hook,
		})
	end,
} -- For comments
