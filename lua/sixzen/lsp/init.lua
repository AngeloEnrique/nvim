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

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    -- if client.name == "tsserver" then
    --   client.server_capabilities.document_formatting = false
    -- end
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf
    if client.name == "angularls" then
      client.server_capabilities.renameProvider = false
    end
    if client.name == "jdtls" then
      if JAVA_DAP_ACTIVE then
        require("jdtls").setup_dap()
        require("jdtls.dap").setup_dap_main_class_configs()
      end
      -- client.server_capabilities.document_formatting = false
      -- vim.keymap.set("n", "<leader>ih", function()
      --   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
      -- end)
    end
    if client.name == "eslint" then
      -- if require("null-ls").is_registered "prettier" then
      --   client.server_capabilities.document_formatting = false
      -- else
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "LspEslintFixAll",
      })
      -- end
    end
    -- if client.server_capabilities.inlayHintProvider then
    --   vim.keymap.set("n", "<leader>ih", function()
    --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
    --   end)
    -- end
    if
      not client:supports_method "textDocument/willSaveWaitUntil"
      and client:supports_method "textDocument/formatting"
    then
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
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover information" }))
    vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Show signature help" }))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    vim.keymap.set({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, vim.tbl_extend("force", opts, { desc = "Run Codelens" }))
    vim.keymap.set({ "n" }, "<leader>cC", function() vim.lsp.codelens.enable(true, { bufnr = bufnr }) end, vim.tbl_extend("force", opts, { desc = "Refresh & Display Codelens" }))
    -- vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
    vim.keymap.set({ "n" }, "<leader>cA", lspUtils.action.source, vim.tbl_extend("force", opts, { desc = "Source actions" }))
    -- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
  end,
})

-- M.on_attach = function(client, bufnr)
--   -- if client.name == "tsserver" then
--   --   client.server_capabilities.document_formatting = false
--   -- end
--   if client.name == "angularls" then
--     client.server_capabilities.renameProvider = false
--   end
--   if client.name == "jdtls" then
--     if JAVA_DAP_ACTIVE then
--       require("jdtls").setup_dap()
--       require("jdtls.dap").setup_dap_main_class_configs()
--     end
--     -- client.server_capabilities.document_formatting = false
--     -- vim.keymap.set("n", "<leader>ih", function()
--     --   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
--     -- end)
--   end
--   if client.name == "eslint" then
--     -- if require("null-ls").is_registered "prettier" then
--     --   client.server_capabilities.document_formatting = false
--     -- else
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       buffer = bufnr,
--       command = "EslintFixAll",
--     })
--     -- end
--   end
--   -- if client.server_capabilities.inlayHintProvider then
--   --   vim.keymap.set("n", "<leader>ih", function()
--   --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
--   --   end)
--   -- end
--   if client.supports_method "textDocument/formatting" then
--     if FORMAT_ON_SAVE then
--       vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
--       vim.api.nvim_create_autocmd("BufWritePre", {
--         group = augroup,
--         buffer = bufnr,
--         callback = function()
--           lsp_formatting(bufnr)
--         end,
--       })
--     end
--   end
--   local opts = { buffer = bufnr }
--   vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
--   vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
--   vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
--   vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, opts)
--   vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
--   vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
--   vim.keymap.set({ "n" }, "<leader>cA", lspUtils.action.source, opts)
--   -- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
-- end

-- M.capabilities = function()
--   local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
--   local has_blink, blink_nvim_lsp = pcall(require, "blink.cmp")
--   local capabilities = vim.tbl_deep_extend(
--     "force",
--     {},
--     vim.lsp.protocol.make_client_capabilities(),
--     has_cmp and cmp_nvim_lsp.default_capabilities() or {},
--     has_blink and blink_nvim_lsp.get_lsp_capabilities() or {}
--   )
--
--   return capabilities
-- end

M.setup = function(_)
  require "sixzen.lsp.servers"
  require "sixzen.lsp.mapping"
  -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  --   silent = true,
  -- })
end

return M
