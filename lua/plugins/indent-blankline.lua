return {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufRead",
	opts = {
		buftype_exclude = { "terminal" },
		show_trailing_blankline_indent = false,
		show_first_indent_level = false,
		show_current_context = false,
		show_current_context_start = false,
	},
}
