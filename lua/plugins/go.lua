return {
  "olexsmir/gopher.nvim",
  ft = "go",
  config = function()
    local gopher = require "gopher"
    gopher.setup {}
    vim.keymap.set("n", "<leader>cgj", "<cmd>GoTagAdd json<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>cgd", "<cmd>GoTagAdd db<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>cgy", "<cmd>GoTagAdd yaml<CR>", { noremap = true, silent = true })
  end,
  build = function()
    vim.cmd [[silent! GoInstallDeps]]
  end,
}
