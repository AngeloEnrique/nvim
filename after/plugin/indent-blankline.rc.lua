local status, indent = pcall(require, 'indent_blankline')
if (not status) then return end



indent.setup {
  buftype_exclude = { "terminal" },
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  show_current_context = true,
  show_current_context_start = true,
}
