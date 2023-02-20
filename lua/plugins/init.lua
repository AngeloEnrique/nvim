return {
	{ "kyazdani42/nvim-web-devicons", opts = {
		override = {},
		default = true,
	} }, -- File icons
	{
		"tpope/vim-dispatch",
		cmd = { "Make", "Dispatch" },
	},
	"tpope/vim-surround",
	"tpope/vim-repeat",
	"tpope/vim-rhubarb",
	"tpope/vim-dotenv",
	"tpope/vim-eunuch",
	"tpope/vim-sleuth",
	{
		"axelvc/template-string.nvim",
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact", "python" },
		opts = {
			filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "python" }, -- filetypes where the plugin is active
			jsx_brackets = true, -- must add brackets to jsx attributes
			remove_template_string = false, -- remove backticks when there are no template string
			restore_quotes = {
				-- quotes used when "remove_template_string" option is enabled
				normal = [[']],
				jsx = [["]],
			},
		},
	},
	{ "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim", config = true },
	"mg979/vim-visual-multi",
	{
		"rmagatti/alternate-toggler",
		config = function()
			vim.keymap.set("n", "<leader>ta", "<cmd>ToggleAlternate<cr>")
		end,
	},
	{
		"folke/neodev.nvim",
		lazy = true,
	},

	"github/copilot.vim", -- Github Copilot

	"SmiteshP/nvim-navic", -- Breadcrumb
	{ "norcalli/nvim-colorizer.lua", opts = {
		"*",
	} },
}
