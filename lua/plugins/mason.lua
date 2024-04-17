return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local mason = require "mason"
    local lspconfig = require "mason-lspconfig"

    mason.setup {}
    lspconfig.setup {
      ensure_installed = {
        "lua_ls",
        "tsserver",
        "jdtls",
        "pyright",
        "gopls",
        "eslint",
        "lemminx",
        "dockerls",
        "rust_analyzer",
        "yamlls",
        "emmet_ls",
        "cssls",
        "tailwindcss",
        "html",
        "jsonls",
        "lua_ls",
      },
    }
  end,
}
