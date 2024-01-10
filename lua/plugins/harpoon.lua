return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require "harpoon"
    harpoon:setup {}
    for i = 1, 5 do
      vim.keymap.set("n", string.format("<leader>%s", i), function()
        harpoon:list():select(i)
      end)
    end
    vim.keymap.set("n", "<leader>hh", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)
    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():append()
    end)

    vim.keymap.set("n", "<C-H>", function()
      harpoon:list():prev()
    end)
    vim.keymap.set("n", "<C-J>", function()
      harpoon:list():next()
    end)
  end,
}
