return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "luarocks.nvim" },
    config = function()
      local rest = require "rest-nvim"
      rest.setup {
        client = "curl",
        env_file = ".env",
        env_pattern = "\\.env$",
        env_edit_command = "tabedit",
        encode_url = true,
        skip_ssl_verification = false,
        custom_dynamic_variables = {},
        logs = {
          level = "info",
          save = true,
        },
        result = {
          split = {
            horizontal = false,
            in_place = false,
            stay_in_current_window_after_split = true,
          },
          behavior = {
            decode_url = true,
            show_info = {
              url = true,
              headers = true,
              http_info = true,
              curl_command = true,
            },
            statistics = {
              enable = true,
              ---@see https://curl.se/libcurl/c/curl_easy_getinfo.html
              stats = {
                { "total_time",      title = "Time taken:" },
                { "size_download_t", title = "Download size:" },
              },
            },
            formatters = {
              json = "jq",
              html = function(body)
                if vim.fn.executable "tidy" == 0 then
                  return body, { found = false, name = "tidy" }
                end
                local fmt_body = vim.fn
                    .system({
                      "tidy",
                      "-i",
                      "-q",
                      "--tidy-mark",
                      "no",
                      "--show-body-only",
                      "auto",
                      "--show-errors",
                      "0",
                      "--show-warnings",
                      "0",
                      "-",
                    }, body)
                    :gsub("\n$", "")

                return fmt_body, { found = true, name = "tidy" }
              end,
            },
          },
          keybinds = {
            buffer_local = true,
            prev = "H",
            next = "L",
          },
        },
        highlight = {
          enable = true,
          timeout = 750,
        },
        ---Example:
        ---
        ---```lua
        ---keybinds = {
        ---  {
        ---    "<localleader>rr", "<cmd>Rest run<cr>", "Run request under the cursor",
        ---  },
        ---  {
        ---    "<localleader>rl", "<cmd>Rest run last<cr>", "Re-run latest request",
        ---  },
        ---}
        ---
        ---```
        ---@see vim.keymap.set
        keybinds = {
          {
            "<localleader>rr",
            "<cmd>Rest run<cr>",
            "Run request under the cursor",
          },
          {
            "<localleader>rl",
            "<cmd>Rest run last<cr>",
            "Re-run latest request",
          },
        },
      }
    end,
  },
  -- {
  --   "NTBBloodbath/rest.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   ft = "http",
  --   config = function()
  --     local rest = require "rest-nvim"
  --
  --     rest.setup {
  --       -- Open request results in a horizontal split
  --       result_split_horizontal = false,
  --       -- Skip SSL verification, useful for unknown certificates
  --       skip_ssl_verification = false,
  --       -- Highlight request on run
  --       highlight = {
  --         enabled = true,
  --         timeout = 150,
  --       },
  --       result = {
  --         -- toggle showing URL, HTTP info, headers at top the of result window
  --         show_url = true,
  --         show_http_info = true,
  --         show_headers = true,
  --         -- executables or functions for formatting response body [optional]
  --         -- set them to nil if you want to disable them
  --         formatters = {
  --           json = "jq",
  --           html = function(body)
  --             return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
  --           end,
  --         },
  --       },
  --       -- Jump to request line on run
  --       jump_to_request = false,
  --       env_file = ".env",
  --       custom_dynamic_variables = {},
  --       yank_dry_run = true,
  --     }
  --
  --     vim.api.nvim_create_autocmd("FileType", {
  --       pattern = "http",
  --       callback = function()
  --         local buff = tonumber(vim.fn.expand "<abuf>", 10)
  --         vim.keymap.set("n", "<leader>rn", rest.run, { noremap = true, buffer = buff })
  --         vim.keymap.set("n", "<leader>rl", rest.last, { noremap = true, buffer = buff })
  --         vim.keymap.set("n", "<leader>rp", function()
  --           rest.run(true)
  --         end, { noremap = true, buffer = buff })
  --       end,
  --     })
  --   end,
  -- },
}
