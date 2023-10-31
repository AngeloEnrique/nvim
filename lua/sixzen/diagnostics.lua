local signs = { Error = "󰅚 ", Warn = " ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- vim.diagnostic.config {
--   virtual_text = {
--     prefix = "●",
--   },
--   update_in_insert = false,
--   float = {
--     source = "always", -- Or "if_many"
--     border = "rounded"
--   },
-- }

vim.diagnostic.config {
  virtual_text = false,
  update_in_insert = false,
  virtual_lines = true,
  float = {
    source = "always", -- Or "if_many"
    border = "rounded"
  },
}
