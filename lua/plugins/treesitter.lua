return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"numToStr/Comment.nvim",
		"JoosepAlviste/nvim-ts-context-commentstring", -- Comments for jsx
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			highlight = {
				enable = true,
				aditional_vim_regex_highlighting = true,
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
				"http",
				"bash",
				"yaml",
				"toml",
				"go",
				"rust",
				"c",
				"cpp",
				"java",
			},
			autotag = {
				enable = true,
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		})
	end,
}
