return {
  "https://gitlab.com/schrieveslaach/sonarlint.nvim",
  event = {
    "BufRead *.java",
    "BufRead *.js",
    "BufRead *.ts",
    "BufRead *.jsx",
    "BufRead *.tsx",
  },
  dependencies = {
    "mfussenegger/nvim-jdtls", -- Java stuffs
  },
  config = function()
    require("sonarlint").setup {
      server = {
        cmd = {
          "sonarlint-language-server",
          -- Ensure that sonarlint-language-server uses stdio channel
          "-stdio",
          "-analyzers",
          -- paths to the analyzers you need, using those for python and java in this example
          -- vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarpython.jar",
          -- vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarcfamily.jar",
          vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarjava.jar",
          vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarjs.jar",
        },
        settings = {
          sonarlint = {
            test = "test",
          },
        },
      },
      filetypes = {
        -- Tested and working
        -- "python",
        -- "cpp",
        -- Requires nvim-jdtls, otherwise an error message will be printed
        "java",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
      },
    }
  end,
}
