return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
  },
  event = "VeryLazy",
  config = function()
    require("harpoon").setup()
    local quick_binds = vim.g.harpoon_quick_binds or 5
    for i = 1, quick_binds do
      vim.keymap.set("n", string.format("<leader>%s", i), function()
        require("harpoon.ui").nav_file(i)
      end, { noremap = true, silent = true, expr = false })
    end
    vim.keymap.set("n", "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>")
    vim.keymap.set("n", "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>")
  end,
}
