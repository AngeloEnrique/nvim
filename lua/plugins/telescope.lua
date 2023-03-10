return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-telescope/telescope-file-browser.nvim" },
		{ "nvim-telescope/telescope-project.nvim" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local fb_actions = require("telescope").extensions.file_browser.actions
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
			color_devicons = true,
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
				file_browser = {
					theme = "dropdown",
					-- disables netrw add use telescope-file-browser in its place
					hijack_netrw = true,
					sorting_strategy = "ascending",
					scroll_strategy = "cycle",
					mappings = {
						-- your custom inset mode mappings
						["i"] = {
							["<C-w>"] = function()
								vim.cmd("normal vbd")
							end,
						},
						["n"] = {
							["N"] = fb_actions.create,
							["h"] = fb_actions.goto_parent_dir,
							["/"] = function()
								vim.cmd("startinsert")
							end,
						},
					},
				},
				project = {
					-- base_dirs = {
					-- 	"~/dev/src",
					-- 	{ "~/dev/src2" },
					-- 	{ "~/dev/src3", max_depth = 4 },
					-- 	{ path = "~/dev/src4" },
					-- 	{ path = "~/dev/src5", max_depth = 2 },
					-- },
					hidden_files = true, -- default: false
					theme = "dropdown",
					order_by = "recent",
					search_by = "title",
					sync_with_nvim_tree = true, -- default false
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("file_browser")
		telescope.load_extension("project")

		local opts = { noremap = true, silent = true }
		vim.keymap.set(
			"n",
			";f",
			'<cmd>lua require("telescope.builtin").find_files({ no_ignore = false, hidden = true })<cr>',
			opts
		)
		vim.keymap.set("n", ";p", "<cmd>lua require'telescope'.extensions.project.project{}<CR>", opts)
		vim.keymap.set("n", ";r", '<cmd>lua require("telescope.builtin").live_grep()<cr>', opts)
		vim.keymap.set("n", ";b", '<cmd>lua require("telescope.builtin").buffers()<cr>', opts)
		vim.keymap.set("n", ";h", '<cmd>lua require("telescope.builtin").help_tags()<cr>', opts)
		vim.keymap.set("n", ";;", '<cmd>lua require("telescope.builtin").resume()<cr>', opts)
		vim.keymap.set("n", ";e", '<cmd>lua require("telescope.builtin").diagnostics()<cr>', opts)
		vim.keymap.set("n", ";gb", '<cmd>lua require("telescope.builtin").git_branches()<cr>', opts)
		vim.keymap.set("n", ";gf", '<cmd>lua require("telescope.builtin").git_files()<cr>', opts)
		vim.keymap.set("n", ";gcc", '<cmd>lua require("telescope.builtin").git_commits()<cr>', opts)
		vim.keymap.set("n", ";gcf", '<cmd>lua require("telescope.builtin").git_bcommits()<cr>', opts)
		vim.keymap.set(
			"n",
			";c",
			'<cmd>lua require("telescope.builtin").find_files({ prompt_title = "< Neovim >", cwd = "$HOME/.config/nvim/", cwd_to_path = true }) <CR>',
			opts
		)
	end,
}
