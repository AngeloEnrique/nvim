-- local statusline_hl = vim.api.nvim_get_hl_by_name("StatusLine", true)
-- local copilot_hl = vim.api.nvim_get_hl_by_name("CmpItemKindCopilot", true)
-- vim.api.nvim_set_hl(0, "SLCopilot", { fg = copilot_hl.foreground, bg = statusline_hl.background })
-- vim.cmd [[highlight SLCopilot guifg=#6CC644 guibg=#44475a gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextChar guifg=#5e5f69 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextStart guibg=#44475a gui=nocombine]]
vim.cmd [[highlight IndentBlanklineChar guifg=#3c3d49 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineSpaceChar guifg=#3c3d49 gui=nocombine]]
