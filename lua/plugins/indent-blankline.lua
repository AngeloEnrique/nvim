return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function()
    local ibl = require "ibl"
    vim.api.nvim_set_hl(0, "IblChar", { fg = "#3c3d49" })
    vim.api.nvim_set_hl(0, "IblScopeChar", { fg = "#5e5f69" })
    vim.api.nvim_set_hl(0, "IblScopeFirstLine", { bg = "#44475a" })
    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    ibl.setup {
      scope = {
        show_start = false,
        highlight = "IblScopeChar",
      },
      indent = {
        highlight = "IblChar",
      },
      exclude = {
        buftypes = { "terminal" },
        filetypes = { "alpha", "dashboard", "NvimTree", "neo-tree", "oil" },
      },
    }
  end,
}
