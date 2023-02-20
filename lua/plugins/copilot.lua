return {
	"zbirenbaum/copilot.lua",
	dependencies = {
		{
			"zbirenbaum/copilot-cmp",
			opts = {
				formatters = {
					insert_text = require("copilot_cmp.format").remove_existing,
				},
			},
		},
	},
	opts = {
		panel = {
			enabled = false,
		},
		suggestion = {
			enabled = false,
		},
	},
}
