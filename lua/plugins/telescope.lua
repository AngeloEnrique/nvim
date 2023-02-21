return {
	"nvim-telescope/telescope.nvim",
	keys = { { ";" } },
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		-- function telescope_buffer_dir()
		--   return vim.fn.expand('%:p:h')
		-- end

		telescope.setup({
			defaults = {
				mappings = {
					n = {
						["q"] = actions.close,
					},
				},
			},
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "ignore_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
			},
		})

		telescope.load_extension("fzf")

		local opts = { noremap = true, silent = true }
		vim.keymap.set(
			"n",
			";f",
			'<cmd>lua require("telescope.builtin").find_files({ no_ignore = false, hidden = true })<cr>',
			opts
		)
		vim.keymap.set("n", ";r", '<cmd>lua require("telescope.builtin").live_grep()<cr>', opts)
		vim.keymap.set("n", ";b", '<cmd>lua require("telescope.builtin").buffers()<cr>', opts)
		vim.keymap.set("n", ";t", '<cmd>lua require("telescope.builtin").help_tags()<cr>', opts)
		vim.keymap.set("n", ";;", '<cmd>lua require("telescope.builtin").resume()<cr>', opts)
		vim.keymap.set("n", ";e", '<cmd>lua require("telescope.builtin").diagnostics()<cr>', opts)
	end,
}
