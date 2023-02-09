return {
	{ "lewis6991/gitsigns.nvim", config = true },
	{
		"dinhhuy258/git.nvim",
		config = {
			keymaps = {
				-- Open blame window
				blame = "<Leader>gb",
				-- Open file/folder in git repository
				browse = "<Leader>go",
			},
		},
	}, -- For git blame and browse
}
