return {
  "nvim-lualine/lualine.nvim", -- Statusline
  event = "UiEnter",
  enabled = false,
  config = function()
    local status, lualine = pcall(require, "lualine")
    if not status then
      return
    end

    local window_width_limit = 100

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand "%:t") ~= 1
      end,
      hide_in_width = function()
        return vim.o.columns > window_width_limit
      end,
    }

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

    local icons = require "sixzen.icons"

    lualine.setup {
      options = {
        icons_enabled = true,
        theme = "catppuccin",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "filename",
            file_status = true, -- displays file status
            path = 1,           -- 0 = just filename
          },
          {
            "diff",
            -- Is it me or the symbol for modified us really weird
            symbols = { added = " ", modified = "柳", removed = " " },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = "", warn = "", info = "", hint = "" },
          },
          {
            -- LSP
            function(msg)
              msg = msg or "LS Inactive"
              local buf_clients = vim.lsp.get_active_clients()
              if next(buf_clients) == nil then
                -- TODO: clean up this if statement
                if type(msg) == "boolean" or #msg == 0 then
                  return "LS Inactive"
                end
                return msg
              end
              local buf_ft = vim.bo.filetype
              local buf_client_names = {}
              local copilot_active = false

              -- add client
              for _, client in pairs(buf_clients) do
                if client.name ~= "null-ls" and client.name ~= "copilot" then
                  table.insert(buf_client_names, client.name)
                end

                if client.name == "copilot" then
                  copilot_active = true
                end
              end

              -- add formatter
              local supported_formatters = formatters_list(buf_ft)
              vim.list_extend(buf_client_names, supported_formatters)

              -- add linter
              local supported_linters = linter_list(buf_ft)
              vim.list_extend(buf_client_names, supported_linters)

              local unique_client_names = vim.fn.uniq(buf_client_names)

              local language_servers = "[" .. table.concat(unique_client_names, ", ") .. "]"

              if copilot_active then
                -- language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
                language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. " "
                -- language_servers = language_servers .. "  " .. icons.git.Octoface .. ""
              end

              return language_servers
            end,
            separator = icons.ui.DividerLeft,
            color = { gui = "bold" },
            cond = conditions.hide_in_width,
          },
          "filetype",
          "encoding",
        },
        lualine_y = {
          "progress",
        },
        lualine_z = {
          "location",
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            file_status = true, -- displays file status
            path = 1,           -- 1 = relative path
          },
        },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "fugitive" },
    }
  end,
}
