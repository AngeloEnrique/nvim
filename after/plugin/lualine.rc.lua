local status, lualine = pcall(require, 'lualine')
if (not status) then return end

local colors = {
  yellow = '#ECBE7B',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#98be65',
  orange = '#FF8800',
  violet = '#a9a1e1',
  magenta = '#c678dd',
  blue = '#51afef',
  red = '#ec5f67',
  white = '#fff'
}

lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'dracula',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { {
      'filename',
      file_status = true, -- displays file status
      path = 0 -- 0 = just filename
    } },
    lualine_x = {
      { 'diagnostics', sources = { 'nvim_diagnostic' }, symbols = { error = '', warn = '', info = '', hint = '' } },
      {
        'lsp_progress',
        -- display_components = { 'lsp_client_name', { 'title', 'percentage', 'message' } },
        -- With spinner
        display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
        colors = {
          percentage      = colors.white,
          title           = colors.white,
          message         = colors.white,
          spinner         = colors.white,
          lsp_client_name = colors.violet,
          use             = true,
        },
        separators = {
          component = ' ',
          progress = ' | ',
          message = { pre = '(', post = ')' },
          percentage = { pre = '', post = '%% ' },
          title = { pre = '', post = ': ' },
          lsp_client_name = { pre = '  [', post = ']' },
          spinner = { pre = '', post = '' },
          -- message = { commenced = 'In Progress', completed = 'Completed' },
        },
        -- display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
        timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
        -- spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
        max_message_length = 30,
      },
      'encoding',
      'filetype'
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { {
      'filename',
      file_status = true, -- displays file status
      path = 1 -- 1 = relative path
    } },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = { 'fugitive' }
}
