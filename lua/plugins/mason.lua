return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  event = "VeryLazy",
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
        "vtsls",
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
        "angularls",
      },
    }
  end,
}
