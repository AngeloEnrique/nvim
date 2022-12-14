local status, nvim_lsp = pcall(require, 'lspconfig')
if (not status) then return end
local status2, navic = pcall(require, 'nvim-navic')

local JAVA_DAP_ACTIVE = true
local protocol = require('vim.lsp.protocol')

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider and status2 then
    navic.attach(client, bufnr)
  end
  if client.name == 'tsserver' then
    client.server_capabilities.document_formatting = false
  end
  if client.name == 'jdt.ls' then
    if JAVA_DAP_ACTIVE then
      require('jdtls').setup_dap()
      require('jdtls.dap').setup_dap_main_class_configs()
    end
    client.server_capabilities.document_formatting = false
  end
  -- formatting
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
    vim.api.nvim_command [[augroup END]]
  end
end

nvim_lsp.pyright.setup {
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'off',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      }
    }
  }
}

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" },
}

nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      }
    }
  }
}

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = {
    prefix = '●'
  },
  update_in_insert = true,
  float = {
    source = "always", -- Or "if_many"
  },
})
