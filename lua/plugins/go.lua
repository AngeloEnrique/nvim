return {
  "olexsmir/gopher.nvim",
  ft = "go",
  config = function()
    local gopher = require "gopher"
    gopher.setup {}
    vim.keymap.set("n", "<leader>gsj", "<cmd>GoTagAdd json<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>gsd", "<cmd>GoTagAdd db<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>gsy", "<cmd>GoTagAdd yaml<CR>", { noremap = true, silent = true })
  end,
  build = function()
    vim.cmd [[silent! GoInstallDeps]]
  end,
}
