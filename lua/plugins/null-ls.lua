return {
	"jose-elias-alvarez/null-ls.nvim", -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
	event = "BufRead",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.diagnostics.eslint_d.with({
					disgnostics_format = "[eslint] #{m}\n(#{c})",
				}),
				-- null_ls.builtins.diagnostics.eslint,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.eslint_d,
				-- null_ls.builtins.formatting.eslint,
				-- null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.google_java_format,
				null_ls.builtins.diagnostics.zsh,
			},
		})
	end,
}
