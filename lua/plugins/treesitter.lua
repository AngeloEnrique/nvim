return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = {
		highlight = {
			enable = true,
			disable = {},
		},
		indent = {
			enable = true,
			disable = {},
		},
		ensure_installed = {
			"tsx",
			"lua",
			"json",
			"javascript",
			"typescript",
			"html",
			"css",
			"python",
		},
		autotag = {
			enable = true,
		},
		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},
	},
}
