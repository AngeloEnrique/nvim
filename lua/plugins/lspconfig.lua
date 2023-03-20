return {
	"neovim/nvim-lspconfig", -- LSP
	event = "BufRead",
	dependencies = {
		"SmiteshP/nvim-navic", -- Breadcrumb
		"mfussenegger/nvim-jdtls", -- Java stuffs
		"jose-elias-alvarez/null-ls.nvim", -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		{
			"j-hui/fidget.nvim", -- LSP progress
			opts = {
				sources = {
					["null-ls"] = {
						ignore = true,
					},
				},
			},
		},
	},
	config = function()
		local status, nvim_lsp = pcall(require, "lspconfig")
		if not status then
			return
		end
		local status2, navic = pcall(require, "nvim-navic")

		local FORMAT_ON_SAVE = false

		local JAVA_DAP_ACTIVE = true
		local protocol = require("vim.lsp.protocol")
		local lsp_formatting = function(bufnr)
			vim.lsp.buf.format({
				filter = function(client)
					-- apply whatever logic you want (in this example, we'll only use null-ls)
					return client.name == "null-ls"
				end,
				bufnr = bufnr,
			})
		end

		-- if you want to set up formatting on save, you can use this as a callback
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		local on_attach = function(client, bufnr)
			if client.server_capabilities.documentSymbolProvider and status2 then
				navic.attach(client, bufnr)
			end
			if client.name == "tsserver" then
				client.server_capabilities.document_formatting = false
			end
			if client.name == "jdt.ls" then
				if JAVA_DAP_ACTIVE then
					require("jdtls").setup_dap()
					require("jdtls.dap").setup_dap_main_class_configs()
				end
				client.server_capabilities.document_formatting = false
			end
			if client.supports_method("textDocument/formatting") then
				if FORMAT_ON_SAVE then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							lsp_formatting(bufnr)
						end,
					})
				end
			end
		end

		nvim_lsp.pyright.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "off",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
					},
				},
			},
		})

		nvim_lsp.tsserver.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			cmd = { "typescript-language-server", "--stdio" },
		})

		nvim_lsp.tailwindcss.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		nvim_lsp.lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					runtime = {
						version = "LuaJIT",
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
			},
			update_in_insert = true,
			float = {
				source = "always", -- Or "if_many"
			},
		})

		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
		vim.keymap.set("n", "<leader>gK", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
	end,
}
