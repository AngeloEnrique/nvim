TelescopeMapArgs = TelescopeMapArgs or {}

local map_tele = function(key, f, options, buffer, mode)
  mode = mode or "n"

  local rhs = function()
    R("sixzen.telescope")[f](options or {})
  end

  local map_options = {
    remap = false,
    silent = true,
  }
  if buffer then
    map_options.buffer = buffer
  end

  vim.keymap.set(mode, key, rhs, map_options)
end

-- not shure what this line does
vim.api.nvim_set_keymap("c", "<c-r><c-r>", "<Plug>(TelescopeFuzzyCommandSearch)", { noremap = false, nowait = true })

map_tele("<leader>;f", "project_files")
map_tele("<leader>;n", "noice")
map_tele("<leader>;gb", "branches")
map_tele("<leader>;w", "grep_word")
map_tele("<leader>;s", "grep_string")
map_tele("<leader>;c", "find_nvim_config")
map_tele("<leader>;p", "find_nvim_plugin")
map_tele("<leader>;h", "help_tags")
map_tele("<leader>;b", "buffers")
map_tele("<leader>;t", "treesitter")
map_tele("<leader>;er", "file_browser_relative")
map_tele("<leader>;eb", "file_browser")
map_tele("<leader>;gs", "git_status")
map_tele("<leader>;d", "diagnostics")

return map_tele
