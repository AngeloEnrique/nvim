SHOULD_RELOAD_TELESCOPE = false

local reloader = function()
  if SHOULD_RELOAD_TELESCOPE then
    RELOAD "plenary"
    RELOAD "telescope"
    RELOAD "sixzen.telescope.setup"
  end
end

-- local fb_actions = require("telescope").extensions.file_browser.actions
local actions = require "telescope.actions"
local my_actions = require "sixzen.telescope.actions"
local builtin = require "telescope.builtin"

local M = {}

-- M.noice = function()
--   require("telescope").extensions.noice.noice {}
-- end

function M.project_files()
  local opts = { show_untracked = true } -- define here if you want to define something
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files { hidden = true }
  end
end

function M.branches()
  builtin.git_branches {
    attach_mappings = function(_, map)
      map("i", "<c-j>", actions.git_create_branch)
      map("n", "<c-j>", actions.git_create_branch)
      return true
    end,
  }
end

M.find_nvim_config = function()
  builtin.find_files {
    prompt_title = "Neovim",
    cwd = "$HOME/.config/nvim/",
  }
end

M.find_nvim_plugin = function()
  builtin.find_files {
    prompt_title = "Plugins",
    cwd = "$HOME/.config/nvim/lua/plugins/",
    attach_mappings = function(_, map)
      map("i", "<C-t>", my_actions.create_plugin)
      map("i", "<C-d>", my_actions.disable_plugin)
      map("i", "<C-e>", my_actions.enable_plugin)

      return true
    end,
  }
end

function M.grep_string()
  vim.ui.input({ prompt = "Grep for > " }, function(input)
    if input == nil then
      return
    end
    builtin.grep_string { search = input }
  end)
end

function M.grep_word()
  builtin.grep_string { search = vim.fn.expand "<cword>" }
end

function M.live_grep()
  builtin.live_grep {}
end

function M.git_commits()
  builtin.git_commits {}
end

function M.git_buf_commits()
  builtin.git_bcommits {}
end

function M.resume()
  builtin.resume {}
end

function M.find_symbol()
  vim.ui.input({ prompt = "Symbol for > " }, function(input)
    if input == nil then
      return
    end
    builtin.lsp_workspace_symbols { query = input }
  end)
end

function M.my_plugins()
  if vim.fn.isdirectory "~/code/plugins/" == 0 then
    vim.notify("Directory ~/code/plugins does not exists", vim.log.levels.WARN, { title = "Telescope Mappings" })
    return
  end
  builtin.find_files {
    cwd = "~/code/plugins/",
  }
end

function M.worktree()
  return require("telescope").extensions.git_worktree.git_worktrees()
end

function M.worktree_create()
  return require("telescope").extensions.git_worktree.create_git_worktree()
end

function M.refactor()
  return require("telescope").extensions.refactoring.refactors()
end

-- function M.file_browser_relative()
--   return M.file_browser { path = "%:p:h" }
-- end

-- function M.file_browser(opts)
--   opts = opts or {}
--
--   opts = {
--     path = opts.path,
--     sorting_strategy = "ascending",
--     scroll_strategy = "cycle",
--     layout_config = {
--       prompt_position = "top",
--     },
--     attach_mappings = function(_, map)
--       map("i", "<c-y>", fb_actions.create)
--
--       return true
--     end,
--   }
--
--   return require("telescope").extensions.file_browser.file_browser(opts)
-- end

return setmetatable({}, {
  __index = function(_, k)
    reloader()
    if M[k] then
      return M[k]
    else
      return builtin[k]
    end
  end,
})
