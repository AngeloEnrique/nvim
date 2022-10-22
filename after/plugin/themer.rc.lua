local status, themer = pcall(require, 'themer')
if (not status) then return end

themer.setup({
  colorscheme = "dracula",
  transparent = true,
  styles = {
    parameter = { style = 'italic' },
    -- property = { style = 'italic' },
  },
})

-- vim.api.nvim_set_hl(0, "SLCopilot",
-- { fg = "#6CC644", bg = require("themer.modules.core.api").get_cp("dracula").bg.selected })
vim.cmd [[highlight SLCopilot guifg=#6CC644 guibg=#44475a gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextChar guifg=#5e5f69 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextStart guibg=#44475a gui=nocombine]]
vim.cmd [[highlight IndentBlanklineChar guifg=#3c3d49 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineSpaceChar guifg=#3c3d49 gui=nocombine]]
