return {
	{ "kyazdani42/nvim-web-devicons", opts = {
		override = {},
		default = true,
	} }, -- File icons

	"github/copilot.vim", -- Github Copilot

	{ "windwp/nvim-autopairs", opts = {
		disable_filetype = { "TelescopePrompt", "vim" },
	} },
	{ "windwp/nvim-ts-autotag", config = true },

	"SmiteshP/nvim-navic", -- Breadcrumb
	{ "norcalli/nvim-colorizer.lua", opts = {
		"*",
	} },
}
