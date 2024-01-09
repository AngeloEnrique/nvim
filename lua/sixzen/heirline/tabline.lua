local M = {}

local conditions = require "heirline.conditions"
local utils = require "heirline.utils"
local surround_delimeter = { "", "" }

local Align = { provider = "%=" }
local Space = { provider = " " }

local StatusIcon = {
  provider = function(self)
    if self.is_active then
      return " "
    end
    return " "
  end,
  hl = function(self)
    if self.is_active then
      return { fg = "normal_fg", bold = true }
    end
    return { fg = "gray" }
  end,
}

local TablineFileName = {
  provider = function(self)
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local name = vim.fn.fnamemodify(self.filename, ":t")
    if self.filename == "" then
      return "[No Name]"
    end
    if name == nil then
      name = "[No Name]"
    end
    if string.find(name, "filesystem") ~= nil then
      return "[File Explorer]"
    end
    if string.find(name, "Neogit") ~= nil then
      return "[NeoGit]"
    end
    if string.find(name, "COMMIT") ~= nil then
      return "[NeoGit Commit]"
    end
    if string.find(name, "dbui") ~= nil then
      return "DBUI"
    end

    local display_name = project_name .. ":" .. name
    return display_name
  end,
  hl = function(self)
    return { bold = self.is_active }
  end,
}
local Tabblock = utils.surround(surround_delimeter, "mantle", {
  StatusIcon,
  TablineFileName,
  Space,
})

local Tabpage = {
  init = function(self)
    local win = vim.api.nvim_tabpage_get_win(self.tabpage)
    local buf = vim.api.nvim_win_get_buf(win)
    self.filename = vim.api.nvim_buf_get_name(buf)
  end,
  hl = function(self)
    if not self.is_active then
      return { fg = "gray", bg = "base" }
    else
      return { fg = "normal_fg", bg = "base", bold = true }
    end
  end,
  Tabblock,
}

local TabPages = {
  utils.make_tablist(Tabpage),
}
M.TabLine = {
  TabPages,
  Align,
}

vim.o.showtabline = 1
vim.cmd [[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]]

return M
