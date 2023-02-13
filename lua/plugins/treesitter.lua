return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"numToStr/Comment.nvim",
		"JoosepAlviste/nvim-ts-context-commentstring", -- Comments for jsx
		"mrjones2014/nvim-ts-rainbow",
		{ "windwp/nvim-autopairs", opts = {
			disable_filetype = { "TelescopePrompt", "vim" },
		} },
		{ "windwp/nvim-ts-autotag", config = true },
	},
	config = function()
		require("nvim-treesitter.configs").setup({
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
				"markdown",
				"markdown_inline",
				"regex",
				"vim",
			},
			sync_install = true,
			auto_install = true,

			highlight = {
				enable = true,
				aditional_vim_regex_highlighting = false,
				disable = {},
			},
			indent = {
				enable = true,
				disable = {},
			},
			autotag = {
				enable = true,
			},
			rainbow = {
				enable = true,
				extended_mode = true,
				max_file_lines = nil,
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		})
	end,
}
