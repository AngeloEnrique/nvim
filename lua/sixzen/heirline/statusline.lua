local M = {}

local conditions = require "heirline.conditions"
local utils = require "heirline.utils"
local surround_delimeter = { "", "" }
local colors = {
  black = "#000000",
  mantle = "#181825",
  base = "#1e1e2e",
  normal_fg = utils.get_highlight("Normal").fg,
  normal_bg = utils.get_highlight("Normal").bg,
  bright_bg = utils.get_highlight("Folded").bg,
  bright_fg = utils.get_highlight("Folded").fg,
  red = utils.get_highlight("DiagnosticError").fg,
  dark_red = utils.get_highlight("DiffDelete").bg,
  green = utils.get_highlight("String").fg,
  blue = utils.get_highlight("Function").fg,
  gray = utils.get_highlight("NonText").fg,
  orange = utils.get_highlight("Constant").fg,
  purple = utils.get_highlight("Statement").fg,
  cyan = utils.get_highlight("Special").fg,
  diag_warn = utils.get_highlight("DiagnosticWarn").fg,
  diag_error = utils.get_highlight("DiagnosticError").fg,
  diag_hint = utils.get_highlight("DiagnosticHint").fg,
  diag_info = utils.get_highlight("DiagnosticInfo").fg,
  git_del = utils.get_highlight("GitSignsDelete").fg,
  git_add = utils.get_highlight("GitSignsAdd").fg,
  git_change = utils.get_highlight("GitSignsChange").fg,
}
require("heirline").load_colors(colors)
local icons = require "sixzen.icons"
local ViMode = {
  static = {
    mode_names = {
      n = "N",
      no = "N?",
      nov = "N?",
      noV = "N?",
      ["no\22"] = "N?",
      niI = "Ni",
      niR = "Nr",
      niV = "Nv",
      nt = "Nt",
      v = "V",
      vs = "Vs",
      V = "V_",
      Vs = "Vs",
      ["\22"] = "^V",
      ["\22s"] = "^V",
      s = "S",
      S = "S_",
      ["\19"] = "^S",
      i = "I",
      ic = "Ic",
      ix = "Ix",
      R = "R",
      Rc = "Rc",
      Rx = "Rx",
      Rv = "Rv",
      Rvc = "Rv",
      Rvx = "Rv",
      c = "C",
      cv = "Ex",
      r = "...",
      rm = "M",
      ["r?"] = "?",
      ["!"] = "!",
      t = "T",
    },
  },
  provider = function()
    return " "
  end,
  hl = function(self)
    local color = self:mode_color() -- here!
    return { fg = color, bold = true }
  end,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd "redrawstatus"
    end),
  },
}

local FileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}
local FileName = {
  init = function(self)
    self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
    if self.lfilename == "" then
      self.lfilename = "[No Name]"
    end
  end,
  hl = { fg = utils.get_highlight("Directory").fg },
  flexible = 1,
  {
    provider = function(self)
      return self.lfilename
    end,
  },
  {
    provider = function(self)
      return vim.fn.pathshorten(self.lfilename)
    end,
  },
  {
    provider = function(self)
      return vim.fn.fnamemodify(self.filename, ":t")
    end,
  },
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = "[+]",
    hl = { fg = "green" },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "",
    hl = { fg = "orange" },
  },
}

local HelpFileName = {
  condition = function()
    return vim.bo.filetype == "help"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
  end,
  hl = { fg = colors.blue },
}

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = "cyan", bold = true, force = true }
    end
  end,
}

FileNameBlock = utils.surround(
  surround_delimeter,
  "mantle",
  utils.insert(
    FileNameBlock,
    FileIcon,
    utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
    FileFlags
  -- { provider = "%<" }                      -- this means that the statusline is cut here when there's not enough space
  )
)

local FileType = {
  provider = function()
    return string.upper(vim.bo.filetype)
  end,
  hl = { fg = "black", bold = true },
}

FileType = utils.surround(surround_delimeter, "orange", FileType)

local LSPActive = {
  flexible = 2,
  {
    flexible = 1,
    {
      condition = conditions.lsp_attached,
      update = { "LspAttach", "LspDetach" },
      {
        utils.surround(surround_delimeter, "mantle", {
          provider = function()
            local names = {}
            local copilot = false
            local buf_ft = vim.bo.filetype

            local list_registered = function(filetype)
              local s = require "null-ls.sources"
              local available_sources = s.get_available(filetype)
              local registered = {}
              for _, source in ipairs(available_sources) do
                for method in pairs(source.methods) do
                  registered[method] = registered[method] or {}
                  table.insert(registered[method], source.name)
                end
              end
              return registered
            end

            local null_ls = require "null-ls"

            local formatters_list = function(filetype)
              local method = null_ls.methods.FORMATTING
              local registered_providers = list_registered(filetype)
              return registered_providers[method] or {}
            end

            local linter_list = function(filetype)
              local alternative_methods = {
                null_ls.methods.DIAGNOSTICS,
                null_ls.methods.DIAGNOSTICS_ON_OPEN,
                null_ls.methods.DIAGNOSTICS_ON_SAVE,
              }
              local registered_providers = list_registered(filetype)
              local providers_for_methods = vim.tbl_flatten(vim.tbl_map(function(m)
                return registered_providers[m] or {}
              end, alternative_methods))

              return providers_for_methods
            end

            for _, server in pairs(vim.lsp.get_clients{ bufnr = 0 }) do
              if server.name ~= "null-ls" and server.name ~= "copilot" and server.name ~= "emmet_ls" then
                table.insert(names, server.name)
              end
              if server.name == "copilot" then
                copilot = true
              end
            end

            -- add formatter
            local supported_formatters = formatters_list(buf_ft)
            vim.list_extend(names, supported_formatters)

            -- add linter
            local supported_linters = linter_list(buf_ft)
            vim.list_extend(names, supported_linters)

            local unique_client_names = vim.fn.uniq(names)

            if copilot then
              ---@diagnostic disable-next-line: param-type-mismatch
              return " [" .. table.concat(unique_client_names, " ") .. "] " .. icons.git.Octoface .. " "
            else
              ---@diagnostic disable-next-line: param-type-mismatch
              return " [" .. table.concat(unique_client_names, " ") .. "]"
            end
          end,
        }),
        hl = { fg = "gray", bold = true },
      },
    },
    {
      condition = conditions.lsp_attached,
      update = { "LspAttach", "LspDetach" },
      utils.surround(surround_delimeter, "mantle", {
        provider = " [LSP]",
        hl = { fg = "gray", bold = true },
      }),
    },
  },
  {
    provider = "",
  },
}
local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = "%7(%l/%3L%):%2c %P",
  hl = { fg = "black" },
}

Ruler = utils.surround(surround_delimeter, "cyan", Ruler)

-- local ShowMode = {
--   condition = require("noice").api.status.mode.has,
--   {
--     condition = require("noice").api.status.mode.has,
--     utils.surround(surround_delimeter, "purple", {
--       provider = require("noice").api.status.mode.get,
--     }),
--     hl = { fg = "black" },
--   },
-- }

local ScrollBar = {
  static = {
    sbar = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁" },
    -- Another variant, because the more choice the better.
    -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  update = { "CursorMoved", "CursorMovedI", "BufEnter" },
  -- hl = function()
  --   return { fg = "purple", bg = "bright_bg" }
  -- end,
}

local Git = {
  condition = conditions.is_git_repo,
  init = function(self)
    ---@diagnostic disable-next-line: undefined-field
    self.status_dict = vim.b.gitsigns_status_dict
  end,
  hl = { fg = "black" },
  utils.surround(surround_delimeter, "orange", {
    provider = function(self)
      return " " .. self.status_dict.head
    end,
    hl = { bold = true },
  }),
}

local GitDiff = {
  flexible = 3,
  {
    flexible = 2,
    {
      condition = conditions.is_git_repo,
      init = function(self)
        ---@diagnostic disable-next-line: undefined-field
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,
      {
        condition = function(self)
          return self.has_changes
        end,
        utils.surround(surround_delimeter, "mantle", {
          -- {
          --   condition = function(self)
          --     return self.has_changes
          --   end,
          --   provider = "[",
          -- },
          {
            provider = function(self)
              local count = self.status_dict.added or 0
              return count > 0 and (" " .. count)
            end,
            hl = { fg = "git_add" },
          },
          {
            provider = " ",
            condition = function(self)
              return self.status_dict.added ~= 0 and (self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0)
            end,
          },
          {
            provider = function(self)
              local count = self.status_dict.removed or 0
              return count > 0 and (" " .. count)
            end,
            hl = { fg = "git_del" },
          },
          {
            provider = " ",
            condition = function(self)
              return self.status_dict.changed ~= 0 and self.status_dict.removed ~= 0
            end,
          },
          {
            provider = function(self)
              local count = self.status_dict.changed or 0
              return count > 0 and (" " .. count)
            end,
            hl = { fg = "git_change" },
          },
          -- {
          --   condition = function(self)
          --     return self.has_changes
          --   end,
          --   provider = "]",
          -- },
        }),
      },
    },
    {
      condition = conditions.is_git_repo,
      init = function(self)
        ---@diagnostic disable-next-line: undefined-field
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,
      {
        condition = function(self)
          return self.has_changes
        end,
        utils.surround(surround_delimeter, "mantle", {
          {
            condition = function(self)
              return self.has_changes
            end,
            provider = "~[",
          },
          {
            provider = function(self)
              local count = self.status_dict.added or 0
              return count > 0 and ("" .. count)
            end,
            hl = { fg = "git_add" },
          },
          {
            provider = " ",
            condition = function(self)
              return self.status_dict.added ~= 0 and (self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0)
            end,
          },
          {
            provider = function(self)
              local count = self.status_dict.removed or 0
              return count > 0 and ("" .. count)
            end,
            hl = { fg = "git_del" },
          },
          {
            provider = " ",
            condition = function(self)
              return self.status_dict.changed ~= 0 and self.status_dict.removed ~= 0
            end,
          },
          {
            provider = function(self)
              local count = self.status_dict.changed or 0
              return count > 0 and ("" .. count)
            end,
            hl = { fg = "git_change" },
          },
          {
            condition = function(self)
              return self.has_changes
            end,
            provider = "]",
          },
        }),
      },
    },
    {
      provider = "",
    },
  },
}

local Diagnostics = {
  flexible = 3,
  {
    flexible = 2,
    {
      condition = conditions.has_diagnostics,
      static = {
        error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
        warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
        info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
        hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
      },
      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,
      update = { "DiagnosticChanged", "BufEnter" },
      {
        conditon = conditions.has_diagnostics,
        utils.surround(surround_delimeter, "mantle", {
          -- {
          --   provider = "[",
          --   condition = conditions.has_diagnostics,
          -- },
          {
            provider = function(self)
              -- 0 is just another output, we can decide to print it or not!
              return self.errors > 0 and (self.error_icon .. self.errors)
            end,
            hl = { fg = "diag_error" },
          },
          {
            provider = " ",
            condition = function(self)
              return self.errors ~= 0 and (self.warnings ~= 0 or self.info ~= 0 or self.hints ~= 0)
            end,
          },
          {
            provider = function(self)
              return self.warnings > 0 and (self.warn_icon .. self.warnings)
            end,
            hl = { fg = "diag_warn" },
          },
          {
            provider = " ",
            condition = function(self)
              return self.warnings ~= 0 and (self.info ~= 0 or self.hints ~= 0)
            end,
          },
          {
            provider = function(self)
              return self.info > 0 and (self.info_icon .. self.info)
            end,
            hl = { fg = "diag_info" },
          },
          {
            provider = " ",
            condition = function(self)
              return self.info ~= 0 and self.hints ~= 0
            end,
          },
          {
            provider = function(self)
              return self.hints > 0 and (self.hint_icon .. self.hints)
            end,
            hl = { fg = "diag_hint" },
          },
          -- {
          --   provider = "]",
          --   condition = conditions.has_diagnostics,
          -- },
        }),
      },
    },
    {
      condition = conditions.has_diagnostics,
      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,
      update = { "DiagnosticChanged", "BufEnter" },
      {
        condition = conditions.has_diagnostics,
        utils.surround(surround_delimeter, "mantle", {
          {
            provider = "![",
            condition = conditions.has_diagnostics,
          },
          {
            provider = function(self)
              -- 0 is just another output, we can decide to print it or not!
              return self.errors > 0 and self.errors
            end,
            hl = { fg = "diag_error" },
          },
          {
            provider = " ",
            condition = function(self)
              return self.errors ~= 0 and (self.warnings ~= 0 or self.info ~= 0 or self.hints ~= 0)
            end,
          },
          {
            provider = function(self)
              return self.warnings > 0 and self.warnings
            end,
            hl = { fg = "diag_warn" },
          },
          {
            provider = " ",
            condition = function(self)
              return self.warnings ~= 0 and (self.info ~= 0 or self.hints ~= 0)
            end,
          },
          {
            provider = function(self)
              return self.info > 0 and self.info
            end,
            hl = { fg = "diag_info" },
          },
          {
            provider = " ",
            condition = function(self)
              return self.info ~= 0 and self.hints ~= 0
            end,
          },
          {
            provider = function(self)
              return self.hints > 0 and self.hints
            end,
            hl = { fg = "diag_hint" },
          },
          {
            provider = "]",
            condition = conditions.has_diagnostics,
          },
        }),
      },
    },
  },
}
local Align = { provider = "%=" }
local Space = { provider = " " }
-- ViMode = utils.surround({ "", "" }, "bright_bg", { ViMode })

local DefaultStatusline = {
  ViMode,
  Space,
  Git,
  Space,
  FileNameBlock,
  Space,
  Align,
  GitDiff,
  Space,
  Diagnostics,
  Align,
  LSPActive,
  Space,
  -- ShowMode,
  Space,
  FileType,
  Space,
  Ruler,
  Space,
  ScrollBar,
  Space,
  ViMode,
}

local InactiveStatusline = {
  condition = conditions.is_not_active,
  FileType,
  Space,
  FileName,
  Align,
  -- ShowMode,
}

local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches {
      buftype = { "nofile", "prompt", "help", "quickfix" },
      filetype = { "^git.*", "fugitive" },
    }
  end,
  FileType,
  Space,
  HelpFileName,
  Align,
  -- ShowMode,
}

M.StatusLines = {
  hl = function()
    if conditions.is_active() then
      return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,
  fallthrough = false,
  static = {
    mode_colors_map = {
      n = "blue",
      i = "green",
      v = "cyan",
      V = "cyan",
      ["\22"] = "cyan",
      c = "orange",
      s = "purple",
      S = "purple",
      ["\19"] = "purple",
      R = "orange",
      r = "orange",
      ["!"] = "red",
      t = "green",
    },
    mode_color = function(self)
      local mode = conditions.is_active() and vim.fn.mode() or "n"
      return self.mode_colors_map[mode]
    end,
  },
  SpecialStatusline,
  InactiveStatusline,
  DefaultStatusline,
}

return M
