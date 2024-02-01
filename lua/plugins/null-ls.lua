return {
  "nvimtools/none-ls.nvim",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local null_ls = require "null-ls"
    local not_check = {
      "typescript",
      "typescriptreact",
      "javascript",
      "javascriptreact",
    }
    null_ls.setup {
      sources = {
        -- null_ls.builtins.diagnostics.eslint_d.with {
        --   disgnostics_format = "[eslint] #{m}\n(#{c})",
        -- },
        -- null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.formatting.eslint_d,
        -- null_ls.builtins.formatting.eslint,
        null_ls.builtins.formatting.prettierd.with {
          condition = function(utils)
            local find = vim.fs.find({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.yml",
              ".prettierrc.yaml",
              ".prettierrc.json5",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.toml",
              "prettier.config.js",
              "prettier.config.cjs",
            }, {
              upward = true,
              stop = vim.fs.dirname(tostring(vim.fn.getcwd())),
              path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
            })
            return not vim.tbl_isempty(find)
          end,
        },
        -- null_ls.builtins.formatting.google_java_format,
        -- null_ls.builtins.diagnostics.zsh,
      },
    }
  end,
}
