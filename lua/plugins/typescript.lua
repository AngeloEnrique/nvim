return {
  "pmizio/typescript-tools.nvim",
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact"},
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  config = function()
    local on_attach = require("sixzen.lsp").on_attach
    local capabilities = require("sixzen.lsp").capabilities()

    require("typescript-tools").setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        expose_as_code_action = "all",
        code_lens = "all",
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeCompletionsForModuleExports = true,
        },
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = true,
        },
      },
    }
  end,
}
