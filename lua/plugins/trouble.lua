return {
  "folke/trouble.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("trouble").setup {}
    -- Lua
    vim.keymap.set("n", "<leader>kk", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>kw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>kd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>kl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>kq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
    vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })
  end,
}
