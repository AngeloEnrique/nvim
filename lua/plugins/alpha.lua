return {
  "goolord/alpha-nvim",
  enabled = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local function max_len_line(lines)
      local max_len = 0

      for _, line in ipairs(lines) do
        local line_len = line:len()
        if line_len > max_len then
          max_len = line_len
        end
      end

      return max_len
    end
    local function align_center(container, lines, alignment)
      local output = {}
      local max_len = max_len_line(lines)

      for _, line in ipairs(lines) do
        local padding = string.rep(" ", (math.max(container.width, max_len) - line:len()) * alignment)
        table.insert(output, padding .. line)
      end

      return output
    end
    local banner = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
    }
    local icons = require "sixzen.icons"
    local header = {
      type = "text",
      val = function()
        local alpha_wins = vim.tbl_filter(function(win)
          local buf = vim.api.nvim_win_get_buf(win)
          return vim.api.nvim_buf_get_option(buf, "filetype") == "alpha"
        end, vim.api.nvim_list_wins())
        return banner
      end,
      opts = {
        position = "center",
        hl = "Label",
      },
    }

    local footer = {
      type = "text",
      val = align_center({ width = 0 }, {
        "",
        "https://github.com/AngeloEnrique",
      }, 0.5),
      opts = {
        position = "center",
        hl = "Number",
      },
    }

    local buttons = {
      opts = {
        hl_shortcut = "Include",
        spacing = 1,
      },
      entries = {
        { "f", icons.ui.FindFile .. "  Find File",   "<CMD>Telescope find_files<CR>" },
        { "n", icons.ui.NewFile .. "  New File",     "<CMD>ene!<CR>" },
        { "r", icons.ui.History .. "  Recent files", ":Telescope oldfiles <CR>" },
        { "t", icons.ui.FindText .. "  Find Text",   "<CMD>Telescope live_grep<CR>" },
        {
          "c",
          icons.ui.Gear .. "  Configuration",
          -- "<CMD>edit " .. "~/.config/nvim/" .. " <CR>",
          -- ":Telescope file_browser path=~/.config/nvim <CR>",
          '<CMD>lua require("telescope.builtin").find_files({ prompt_title = "< Neovim >", cwd = "$HOME/.config/nvim/",}) <CR>',
        },
        { "q", icons.ui.Close .. "  Quit", "<CMD>quit<CR>" },
      },
    }
    local function resolve_buttons(theme_name, button_section)
      if button_section.val and #button_section.val > 0 then
        return button_section.val
      end

      local selected_theme = require("alpha.themes." .. theme_name)
      local val = {}
      for _, entry in pairs(button_section.entries) do
        local on_press = function()
          local sc_ = entry[1]:gsub("%s", ""):gsub("SPC", "<leader>")
          local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
          vim.api.nvim_feedkeys(key, "normal", false)
        end
        local button_element = selected_theme.button(entry[1], entry[2], entry[3])
        -- this became necessary after recent changes in alpha.nvim (06ade3a20ca9e79a7038b98d05a23d7b6c016174)
        button_element.on_press = on_press

        button_element.opts = vim.tbl_extend("force", button_element.opts, entry[4] or button_section.opts or {})

        table.insert(val, button_element)
      end
      return val
    end
    local function resolve_config(theme_name)
      local selected_theme = require "alpha.themes.dashboard"
      local resolved_section = selected_theme.section
      local section = {
        header = header,
        buttons = buttons,
        footer = footer,
      }

      for name, el in pairs(section) do
        for k, v in pairs(el) do
          if name:match "buttons" and k == "entries" then
            resolved_section[name].val = resolve_buttons(theme_name, el)
          elseif v then
            resolved_section[name][k] = v
          end
        end

        resolved_section[name].opts = el.opts or {}
      end

      local opts = {}
      selected_theme.config.opts = vim.tbl_extend("force", selected_theme.config.opts, opts)

      return selected_theme.config
    end
    local config = resolve_config "dashboard"
    require("alpha").setup(config)
  end,
}
