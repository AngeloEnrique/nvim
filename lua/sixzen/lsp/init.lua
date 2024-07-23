local M = {}

local FORMAT_ON_SAVE = false

local JAVA_DAP_ACTIVE = true

local lspUtils = require "sixzen.lsp.utils"

-- local border = "rounded"
-- local protocol = require "vim.lsp.protocol"
local lsp_formatting = function(bufnr)
  vim.lsp.buf.format {
    filter = function(client)
      -- apply whatever logic you want (in this example, we'll only use null-ls)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  }
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

M.on_attach = function(client, bufnr)
  -- if client.name == "tsserver" then
  --   client.server_capabilities.document_formatting = false
  -- end
  if client.name == "angularls" then
    client.server_capabilities.renameProvider = false
  end
  if client.name == "jdtls" then
    if JAVA_DAP_ACTIVE then
      require("jdtls").setup_dap()
      require("jdtls.dap").setup_dap_main_class_configs()
    end
    -- client.server_capabilities.document_formatting = false
    vim.keymap.set("n", "<leader>ih", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
    end)
  end
  if client.name == "eslint" then
    if require("null-ls").is_registered "prettier" then
      client.server_capabilities.document_formatting = false
    else
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end
  end
  if client.server_capabilities.inlayHintProvider then
    vim.keymap.set("n", "<leader>ih", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
    end)
  end
  if client.supports_method "textDocument/formatting" then
    if FORMAT_ON_SAVE then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          lsp_formatting(bufnr)
        end,
      })
    end
  end
  local opts = { buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set({ "n" }, "<leader>cA", lspUtils.action.source, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format { async = true }
  end, opts)
end

M.capabilities = function()
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {}
  )

  return capabilities
end

M.setup = function(_)
  require "sixzen.lsp.servers"
  require "sixzen.lsp.mapping"
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
  })
end

return M
