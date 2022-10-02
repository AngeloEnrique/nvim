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
