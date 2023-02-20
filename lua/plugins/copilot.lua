return {
	"zbirenbaum/copilot.lua",
	dependencies = {
		{
			"zbirenbaum/copilot-cmp",
			config = {
				formatters = {
					insert_text = require("copilot_cmp.format").remove_existing,
				},
			},
		},
	},
	config = {
		panel = {
			enabled = false,
		},
		suggestion = {
			enabled = false,
		},
	},
}
