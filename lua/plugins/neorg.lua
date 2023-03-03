return {
	"nvim-neorg/neorg",
	build = ":Neorg sync-parsers",
	keys = {
		{ "<leader>no", "<cmd>Neorg index<cr>", desc = "Neorg" },
	},
	dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-treesitter/nvim-treesitter" } },
	opts = {
		load = {
			["core.defaults"] = {}, -- Loads default behaviour
			["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
			["core.norg.dirman"] = { -- Manages Neorg workspaces
				config = {
					workspaces = {
						notes = "~/notes",
					},
					default_workspace = "notes",
				},
			},
			["core.norg.completion"] = {
				config = {
					engine = "nvim-cmp",
				},
			},
		},
	},
}
