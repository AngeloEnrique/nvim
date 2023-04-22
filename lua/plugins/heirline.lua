return {
  "rebelot/heirline.nvim",
  event = "UiEnter",
  dependencies = {
    { "lewis6991/gitsigns.nvim", config = true },
  },
  config = function()
    local conditions = require "heirline.conditions"
    local utils = require "heirline.utils"
    local colors = {
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
        return " "
      end,
      hl = function(self)
        local color = self:mode_color() -- here!
        return { bg = color, bold = true }
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
        self.icon, self.icon_color =
            require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
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
        if self.lfilename == "" then self.lfilename = "[No Name]" end
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
        end
      }
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

    FileNameBlock = utils.insert(
      FileNameBlock,
      FileIcon,
      utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
      FileFlags
    -- { provider = "%<" }                      -- this means that the statusline is cut here when there's not enough space
    )

    local FileType = {
      provider = function()
        return string.upper(vim.bo.filetype)
      end,
      hl = { fg = utils.get_highlight("Type").fg, bold = true },
    }

    local LSPActive = {
      flexible = 2,
      {
        flexible = 1,
        {
          condition = conditions.lsp_attached,
          update = { "LspAttach", "LspDetach" },
          provider = function()
            local names = {}
            local copilot = false
            for _, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
              if server.name ~= "null-ls" and server.name ~= "copilot" and server.name ~= "emmet_ls" then
                table.insert(names, server.name)
              end
              if server.name == "copilot" then
                copilot = true
              end
            end
            if copilot then
              return " [" .. table.concat(names, " ") .. "] " .. icons.git.Octoface .. " "
            else
              return " [" .. table.concat(names, " ") .. "]"
            end
          end,
          hl = { fg = "green", bold = true },
        },
        {
          condition = conditions.lsp_attached,
          update = { "LspAttach", "LspDetach" },
          provider = " [LSP]",
          hl = { fg = "green", bold = true },
        },
      },
      {
        provider = ""
      }
    }
    local Ruler = {
      -- %l = current line number
      -- %L = number of lines in the buffer
      -- %c = column number
      -- %P = percentage through file of displayed window
      provider = "%7(%l/%3L%):%2c %P",
    }

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
      hl = function()
        return { fg = "purple", bg = "bright_bg" }
      end,
    }

    local Git = {
      condition = conditions.is_git_repo,
      init = function(self)
        ---@diagnostic disable-next-line: undefined-field
        self.status_dict = vim.b.gitsigns_status_dict
      end,
      hl = { fg = "orange" },
      {
        provider = function(self)
          return " " .. self.status_dict.head
        end,
        hl = { bold = true },
      },
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
            self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or
                self.status_dict.changed ~= 0
          end,
          {
            condition = function(self)
              return self.has_changes
            end,
            provider = "[",
          },
          {
            provider = function(self)
              local count = self.status_dict.added or 0
              return count > 0 and (" " .. count)
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
              return count > 0 and (" " .. count)
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
              return count > 0 and (" " .. count)
            end,
            hl = { fg = "git_change" },
          },
          {
            condition = function(self)
              return self.has_changes
            end,
            provider = "]",
          },
        },
        {
          condition = conditions.is_git_repo,
          init = function(self)
            ---@diagnostic disable-next-line: undefined-field
            self.status_dict = vim.b.gitsigns_status_dict
            self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or
                self.status_dict.changed ~= 0
          end,
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
        },
        {
          provider = ""
        }
      }
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
            provider = "[",
            condition = conditions.has_diagnostics,
          },
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
          {
            provider = "]",
            condition = conditions.has_diagnostics,
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
        }
      }
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
      Space,
      LSPActive,
      Space,
      Align,
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
    }
    local StatusLines = {
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

    -- we redefine the filename component, as we probably only want the tail and not the relative path
    local TablineFileName = {
      provider = function(self)
        -- self.filename will be defined later, just keep looking at the example!
        local filename = self.filename
        filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
        return filename
      end,
      hl = function(self)
        return { bold = self.is_active or self.is_visible, italic = true }
      end,
    }

    -- this looks exactly like the FileFlags component that we saw in
    -- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
    -- also, we are adding a nice icon for terminal buffers.
    local TablineFileFlags = {
      {
        condition = function(self)
          return vim.api.nvim_buf_get_option(self.bufnr, "modified")
        end,
        provider = "[+]",
        hl = { fg = "green" },
      },
      {
        condition = function(self)
          return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
              or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
        end,
        provider = function(self)
          if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
            return "  "
          else
            return ""
          end
        end,
        hl = { fg = "orange" },
      },
    }

    -- Here the filename block finally comes together
    local TablineFileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(self.bufnr)
      end,
      hl = function(self)
        if self.is_active then
          return {}
          -- why not?
        elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
          return { fg = "gray" }
        else
          return "TabLine"
        end
      end,
      FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
      TablineFileName,
      TablineFileFlags,
    }


    local TablinePicker = {
      condition = function(self)
        return self._show_picker
      end,
      init = function(self)
        local bufname = vim.api.nvim_buf_get_name(self.bufnr)
        bufname = vim.fn.fnamemodify(bufname, ":t")
        local label = bufname:sub(1, 1)
        local i = 2
        while self._picker_labels[label] do
          if i > #bufname then
            break
          end
          label = bufname:sub(i, i)
          i = i + 1
        end
        self._picker_labels[label] = self.bufnr
        self.label = label
      end,
      provider = function(self)
        return self.label
      end,
      hl = { fg = "red", bold = true },
    }


    local ViModeTab = {
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
        return "│"
      end,
      hl = function(self)
        if self.is_active then
          local color = self:mode_color() -- here!
          return { fg = color, bold = true }
        end
      end,
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
          vim.cmd.redrawtabline()
        end),
      },
    }

    -- The final touch!
    local TablineBufferBlock = {
      hl = function(self)
        if self.is_active then
          return "TabLineSel"
        else
          return "TabLine"
        end
      end,
      { ViModeTab, TablineFileNameBlock, Space, TablinePicker }
    }

    local get_bufs = function()
      return vim.tbl_filter(function(bufnr)
        return vim.api.nvim_buf_get_option(bufnr, "buflisted")
      end, vim.api.nvim_list_bufs())
    end

    -- initialize the buflist cache
    local buflist_cache = {}

    -- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
    vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
      callback = function()
        vim.schedule(function()
          local buffers = get_bufs()
          for i, v in ipairs(buffers) do
            buflist_cache[i] = v
          end
          for i = #buffers + 1, #buflist_cache do
            buflist_cache[i] = nil
          end

          -- check how many buffers we have and set showtabline accordingly
          if #buflist_cache > 1 then
            vim.o.showtabline = 2 -- always
          else
            vim.o.showtabline = 1 -- only when #tabpages > 1
          end
        end)
      end,
    })

    local BufferLine = utils.make_buflist(
      TablineBufferBlock,
      { provider = " ", hl = { fg = "gray" } },
      { provider = " ", hl = { fg = "gray" } },
      -- out buf_func simply returns the buflist_cache
      function()
        return buflist_cache
      end,
      -- no cache, as we're handling everything ourselves
      false
    )

    vim.keymap.set("n", "<leader>b", function()
      local tabline = require("heirline").tabline
      local buflist = tabline._buflist[1]
      buflist._picker_labels = {}
      buflist._show_picker = true
      vim.cmd.redrawtabline()
      local char = vim.fn.getcharstr()
      local bufnr = buflist._picker_labels[char]
      if bufnr then
        vim.api.nvim_win_set_buf(0, bufnr)
      end
      buflist._show_picker = false
      vim.cmd.redrawtabline()
    end)

    vim.keymap.set("n", "<tab>", ":bnext<cr>", { silent = true, noremap = true })
    vim.keymap.set("n", "<S-tab>", ":bprevious<cr>", { silent = true, noremap = true })

    local Tabpage = {
      provider = function(self)
        return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
      end,
      hl = function(self)
        if not self.is_active then
          return "TabLine"
        else
          return "TabLineSel"
        end
      end,
    }

    local TabPages = {
      -- only show this component if there's 2 or more tabpages
      condition = function()
        return #vim.api.nvim_list_tabpages() >= 2
      end,
      utils.make_tablist(Tabpage),
    }
    local TabLineOffset = {
      condition = function(self)
        local win = vim.api.nvim_tabpage_list_wins(0)[2]
        if win == nil then return false end
        local bufnr = vim.api.nvim_win_get_buf(win)
        self.winid = win

        if vim.bo[bufnr].filetype == "NvimTree" then
          self.title = "NvimTree"
          return true
          -- elseif vim.bo[bufnr].filetype == "TagBar" then
          --     ...
        end
      end,
      provider = function(self)
        local title = self.title
        local width = vim.api.nvim_win_get_width(self.winid)
        local pad = math.ceil((width - #title) / 2)
        return string.rep(" ", pad) .. title .. string.rep(" ", pad)
      end,
      hl = function(self)
        if vim.api.nvim_get_current_win() == self.winid then
          return "TabLineSel"
        else
          return "TabLine"
        end
      end,
    }
    local TabLine = {
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
      BufferLine,
      Align,
      TabPages,
      TabLineOffset
    }

    require("heirline").setup {
      statusline = StatusLines,
      tabline = TabLine
    }
    vim.o.showtabline = 2
    vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
  end,
}
