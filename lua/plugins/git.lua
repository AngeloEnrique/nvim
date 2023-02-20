return {
	{ "lewis6991/gitsigns.nvim", config = true },
	{
		"dinhhuy258/git.nvim",
		opts = {
			default_mappings = false,
			keymaps = {
				blame = "<Leader><Leader>gb",
				-- Close blame window
				quit_blame = "q",
				-- Open blame commit
				blame_commit = "<CR>",
				-- Open file/folder in git repository
				browse = "<Leader><Leader>go",
				-- Open pull request of the current branch
				open_pull_request = "<Leader><Leader>gp",
				-- Create a pull request with the target branch is set in the `target_branch` option
				create_pull_request = "<Leader><Leader>gn",
				-- Opens a new diff that compares against the current index
				diff = "<Leader><Leader>gd",
				-- Close git diff
				diff_close = "<Leader><Leader>gD",
				-- Revert to the specific commit
				revert = "<Leader><Leader>gr",
				-- Revert the current file to the specific commit
			},
		},
	}, -- For git blame and browse
}
