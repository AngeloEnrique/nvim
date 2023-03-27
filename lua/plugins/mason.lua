return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  event = "BufRead",
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
        "clangd",
      },
    }
  end,
}
