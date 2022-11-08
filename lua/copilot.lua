-- Change Github Copilot nodejs version to work
vim.g.copilot_node_command = "~/.nvm/versions/node/v16.17.1/bin/node"

-- remapping
vim.keymap.set('i', '<C-Return>', 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<M-.>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<M-,>', '<Plug>(copilot-previous)')

-- Files enabled

vim.g.copilot_filetypes = {
  ["*"] = false,
  ["javascript"] = true,
  ["typescript"] = true,
  ["javascriptreact"] = true,
  ["typescriptreact"] = true,
  ["lua"] = true,
  ["rust"] = true,
  ["c"] = true,
  ["c#"] = true,
  ["c++"] = true,
  ["go"] = true,
  ["python"] = true,
  ["java"] = true,
}
