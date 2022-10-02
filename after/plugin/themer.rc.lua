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


vim.cmd [[highlight IndentBlanklineContextChar guifg=#5e5f69 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextStart guibg=#44475a gui=nocombine]]
vim.cmd [[highlight IndentBlanklineChar guifg=#3c3d49 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineSpaceChar guifg=#3c3d49 gui=nocombine]]
