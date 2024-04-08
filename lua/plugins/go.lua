return {
  "olexsmir/gopher.nvim",
  ft = "go",
  config = function()
    local gopher = require "gopher"
    gopher.setup {}
    vim.keymap.set("n", "<leader>csj", "<cmd>GoTagAdd json<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>csd", "<cmd>GoTagAdd db<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>csy", "<cmd>GoTagAdd yaml<CR>", { noremap = true, silent = true })
  end,
  build = function()
    vim.cmd [[silent! GoInstallDeps]]
  end,
}
