return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"saadparwaiz1/cmp_luasnip", --cmp luasnip
		"hrsh7th/cmp-path", -- nvim-cmp buffer for paths
		"hrsh7th/cmp-buffer", -- nvim-cmp source for buffer words
		"hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for neovim',s built-in LSP
		"hrsh7th/cmp-nvim-lua", -- nvim-cmp for lua
		"hrsh7th/cmp-git", -- nvim-cmp for git
		"hrsh7th/cmp-cmdline", -- nvim-cmp for cmdline
		"hrsh7th/cmp-nvim-lsp-signature-help", -- nvim-cmp for cmdline
		"L3MON4D3/LuaSnip", -- Snippets
		"zbirenbaum/copilot-cmp", -- Copilot
	},
	event = { "InsertEnter", "CmdlineEnter" },
	config = function()
		local cmp = require("cmp")
		local cmp_window = require("cmp.config.window")
		local cmp_mapping = require("cmp.config.mapping")
		local icons = require("icons")

		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		local function jumpable(dir)
			local luasnip_ok, luasnip = pcall(require, "luasnip")
			if not luasnip_ok then
				return false
			end

			local win_get_cursor = vim.api.nvim_win_get_cursor
			local get_current_buf = vim.api.nvim_get_current_buf

			---sets the current buffer's luasnip to the one nearest the cursor
			---@return boolean true if a node is found, false otherwise
			local function seek_luasnip_cursor_node()
				-- TODO(kylo252): upstream this
				-- for outdated versions of luasnip
				if not luasnip.session.current_nodes then
					return false
				end

				local node = luasnip.session.current_nodes[get_current_buf()]
				if not node then
					return false
				end

				local snippet = node.parent.snippet
				local exit_node = snippet.insert_nodes[0]

				local pos = win_get_cursor(0)
				pos[1] = pos[1] - 1

				-- exit early if we're past the exit node
				if exit_node then
					local exit_pos_end = exit_node.mark:pos_end()
					if (pos[1] > exit_pos_end[1]) or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2]) then
						snippet:remove_from_jumplist()
						luasnip.session.current_nodes[get_current_buf()] = nil

						return false
					end
				end

				node = snippet.inner_first:jump_into(1, true)
				while node ~= nil and node.next ~= nil and node ~= snippet do
					local n_next = node.next
					local next_pos = n_next and n_next.mark:pos_begin()
					local candidate = n_next ~= snippet and next_pos and (pos[1] < next_pos[1])
						or (pos[1] == next_pos[1] and pos[2] < next_pos[2])

					-- Past unmarked exit node, exit early
					if n_next == nil or n_next == snippet.next then
						snippet:remove_from_jumplist()
						luasnip.session.current_nodes[get_current_buf()] = nil

						return false
					end

					if candidate then
						luasnip.session.current_nodes[get_current_buf()] = node
						return true
					end

					local ok
					ok, node = pcall(node.jump_from, node, 1, true) -- no_move until last stop
					if not ok then
						snippet:remove_from_jumplist()
						luasnip.session.current_nodes[get_current_buf()] = nil

						return false
					end
				end

				-- No candidate, but have an exit node
				if exit_node then
					-- to jump to the exit node, seek to snippet
					luasnip.session.current_nodes[get_current_buf()] = snippet
					return true
				end

				-- No exit node, exit from snippet
				snippet:remove_from_jumplist()
				luasnip.session.current_nodes[get_current_buf()] = nil
				return false
			end

			if dir == -1 then
				return luasnip.in_snippet() and luasnip.jumpable(-1)
			else
				return luasnip.in_snippet() and seek_luasnip_cursor_node() and luasnip.jumpable(1)
			end
		end

		local cmp_types = require("cmp.types.cmp")
		local ConfirmBehavior = cmp_types.ConfirmBehavior
		local SelectBehavior = cmp_types.SelectBehavior
		local luasnip = require("luasnip")
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
					luasnip.filetype_extend("javascript", { "javascriptreact" })
					luasnip.filetype_extend("javascript", { "html" })
				end,
			},
			window = {
				completion = cmp_window.bordered(),
				documentation = cmp_window.bordered(),
			},
			mapping = cmp_mapping.preset.insert({
				["<C-k>"] = cmp_mapping(cmp_mapping.select_prev_item(), { "i", "c" }),
				["<C-j>"] = cmp_mapping(cmp_mapping.select_next_item(), { "i", "c" }),
				["<Down>"] = cmp_mapping(cmp_mapping.select_next_item({ behavior = SelectBehavior.Select }), { "i" }),
				["<Up>"] = cmp_mapping(cmp_mapping.select_prev_item({ behavior = SelectBehavior.Select }), { "i" }),
				["<C-d>"] = cmp_mapping.scroll_docs(-4),
				["<C-u>"] = cmp_mapping.scroll_docs(4),
				["<C-y>"] = cmp_mapping({
					i = cmp_mapping.confirm({ behavior = ConfirmBehavior.Replace, select = false }),
					c = function(fallback)
						if cmp.visible() then
							cmp.confirm({ behavior = ConfirmBehavior.Replace, select = false })
						else
							fallback()
						end
					end,
				}),
				["<Tab>"] = cmp_mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					elseif jumpable(1) then
						luasnip.jump(1)
					elseif has_words_before() then
						-- cmp.complete()
						fallback()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp_mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
				["<C-Space>"] = cmp_mapping.complete(),
				["<C-e>"] = cmp_mapping.abort(),
				["<CR>"] = cmp_mapping(function(fallback)
					if cmp.visible() then
						local confirm_opts = vim.deepcopy({
							behavior = ConfirmBehavior.Replace,
							select = false,
						}) -- avoid mutating the original opts below
						local is_insert_mode = function()
							return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
						end
						if is_insert_mode() then -- prevent overwriting brackets
							confirm_opts.behavior = ConfirmBehavior.Insert
						end
						if cmp.confirm(confirm_opts) then
							return -- success, exit early
						end
					end
					fallback() -- if not exited early, always fallback
				end),
			}),
			sources = cmp.config.sources({
				{
					name = "copilot",
					-- keyword_length = 0,
					max_item_count = 3,
					trigger_characters = {
						{
							".",
							":",
							"(",
							"'",
							'"',
							"[",
							",",
							"#",
							"*",
							"@",
							"|",
							"=",
							"-",
							"{",
							"/",
							"\\",
							"+",
							"?",
							" ",
							-- "\t",
							-- "\n",
						},
					},
				},
				{ name = "luasnip" },
				{ name = "nvim_lua" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{
					name = "buffer",
					keyword_length = 4,
					option = {
						get_bufnrs = function()
							local bufs = {}
							for _, win in ipairs(vim.api.nvim_list_wins()) do
								bufs[vim.api.nvim_win_get_buf(win)] = true
							end
							return vim.tbl_keys(bufs)
						end,
					},
				},
				{ name = "path" },
			}),
			formatting = {
				fields = { "kind", "abbr", "menu" },
				max_width = 0,
				kind_icons = icons.kind,
				source_names = {
					nvim_lsp = "(LSP)",
					emoji = "(Emoji)",
					path = "(Path)",
					calc = "(Calc)",
					cmp_tabnine = "(Tabnine)",
					vsnip = "(Snippet)",
					luasnip = "(Snippet)",
					buffer = "(Buffer)",
					tmux = "(TMUX)",
					copilot = "(Copilot)",
					treesitter = "(TreeSitter)",
				},
				duplicates = {
					buffer = 1,
					path = 1,
					nvim_lsp = 0,
					luasnip = 1,
				},
				duplicates_default = 0,
				format = function(entry, vim_item)
					local max_width = 0
					if max_width ~= 0 and #vim_item.abbr > max_width then
						vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
					end

					vim_item.kind = icons.kind[vim_item.kind]

					if entry.source.name == "copilot" then
						vim_item.kind = icons.git.Octoface
						vim_item.kind_hl_group = "CmpItemKindCopilot"
					end

					if entry.source.name == "cmp_tabnine" then
						vim_item.kind = icons.misc.Robot
						vim_item.kind_hl_group = "CmpItemKindTabnine"
					end

					if entry.source.name == "crates" then
						vim_item.kind = icons.misc.Package
						vim_item.kind_hl_group = "CmpItemKindCrate"
					end

					if entry.source.name == "lab.quick_data" then
						vim_item.kind = icons.misc.CircuitBoard
						vim_item.kind_hl_group = "CmpItemKindConstant"
					end

					if entry.source.name == "emoji" then
						vim_item.kind = icons.misc.Smiley
						vim_item.kind_hl_group = "CmpItemKindEmoji"
					end
					local source_names = {
						nvim_lsp = "(LSP)",
						emoji = "(Emoji)",
						path = "(Path)",
						calc = "(Calc)",
						cmp_tabnine = "(Tabnine)",
						vsnip = "(Snippet)",
						luasnip = "(Snippet)",
						buffer = "(Buffer)",
						tmux = "(TMUX)",
						copilot = "(Copilot)",
						treesitter = "(TreeSitter)",
					}
					local duplicates = {
						buffer = 1,
						path = 1,
						nvim_lsp = 0,
						luasnip = 1,
					}
					vim_item.menu = source_names[entry.source.name]
					vim_item.dup = duplicates[entry.source.name] or 0
					return vim_item
				end,
				experimental = {
					native_menu = false,
					ghost_text = true,
				},
			},
		})

		-- Set configuration for specific filetype.
		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({
				{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
			}, {
				{ name = "buffer" },
			}),
		})

		-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})

		cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
			sources = cmp.config.sources({
				{ name = "vim-dadbod-completion" },
			}, {
				{ name = "buffer" },
			}),
		})

		vim.cmd([[
			set completeopt=menuone,noinsert,noselect
			highlight! default link CmpItemKind CmpItemMenuDefault
		]])
	end,
}
