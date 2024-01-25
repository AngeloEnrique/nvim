return {
  "vuki656/package-info.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  event = "VeryLazy",
  config = function()
    local package_info = require "package-info"
    package_info.setup {
      hide_up_to_date = true, -- It hides up to date versions when displaying virtual text
      package_manager = "pnpm",
    }
    vim.keymap.set("n", "<leader>nt", function()
      package_info.toggle()
    end)
    vim.keymap.set("n", "<leader>nu", function()
      package_info.update()
    end)
    vim.keymap.set("n", "<leader>ni", function()
      package_info.install()
    end)
    vim.keymap.set("n", "<leader>nd", function()
      package_info.delete()
    end)
  end,
}
