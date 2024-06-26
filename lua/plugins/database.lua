return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    "tpope/vim-dadbod",
    "kristijanhusak/vim-dadbod-completion",
    "tpope/vim-dotenv",
  },
  keys = { { "<leader><leader>db", ":tab DBUI<cr>" } },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_database_icon = 1
    vim.g.db_ui_force_echo_notifications = 1
    vim.g.db_ui_win_position = "right"
    vim.g.db_ui_winwidth = 80

    vim.cmd [[
    let g:db_ui_table_helpers = {
\        'mysql': {
\          'Count': 'select count(1) from {optional_schema}{table}',
\          'Explain': 'EXPLAIN {last_query}'
\        },
\        'sqlite': {
\          'Describe': 'PRAGMA table_info({table})'
\        },
\        'mongodb': {
\          'Count': '{table}.countDocuments()',
\          'FindOne': '{table}.findOne()'
\        },
\        'mongodb+srv': {
\          'List': '{table}.find()',
\          'Count': '{table}.countDocuments()',
\          'FindOne': '{table}.findOne()'
\        }
\      }
    ]]

    vim.g.db_ui_icons = {
      expanded = {
        db = "▾ 󰆼",
        buffers = "▾ ",
        saved_queries = "▾ ",
        schemas = "▾ ",
        schema = "▾ 󰙅",
        tables = "▾ 󰓱",
        table = "▾ ",
      },
      collapsed = {
        db = "▸ 󰆼",
        buffers = "▸ ",
        saved_queries = "▸ ",
        schemas = "▸ ",
        schema = "▸ 󰙅",
        tables = "▸ 󰓱",
        table = "▸ ",
      },
      saved_query = "",
      new_query = "󰓰",
      tables = "󰓫",
      buffers = "",
      add_connection = "󰆺",
      connection_ok = "✓",
      connection_error = "✕",
    }
  end,
}
