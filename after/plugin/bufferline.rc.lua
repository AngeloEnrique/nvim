local status, bufferline = pcall(require, 'bufferline')
if (not status) then return end

bufferline.setup {
  options = {
    mode = 'tabs',
    separator_style = 'slant',
    always_show_bufferline = false,
    show_buffer_close_icons = false,
    show_close_icons = false,
    color_icons = true
  },
  highlights = {
    separator = {
      fg = '#282a36',
      bg = '#282a36'
    },
    separator_selected = {
      fg = '#282a36',
      -- bg = '#282a36'
    },
    background = {
      -- fg = '#f8f8f2',
      bg = '#282a36'
    },
    buffer_selected = {
      -- fg = '#fdf6e3',
      bold = true
    },
    fill = {
      bg = '#282a36'
    }
  }
}

vim.api.nvim_set_keymap('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', {})
vim.api.nvim_set_keymap('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', {})
