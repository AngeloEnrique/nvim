return {
  -- for lsp features in code cells / embedded code
  "jmbuhr/otter.nvim",
  ft = { "quarto", "markdown" },
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
    },
  },
  config = function()
    local otter = require "otter"
    otter.setup {
      lsp = {
        hover = {
          border = { "", "", "", "", "", "", "", "" },
        },
      },
      buffers = {
        set_filetype = true,
        write_to_disk = true,
      },
      handle_leading_whitespace = true,
    }
    -- vim.keymap.set("n", "gd", function()
    --   otter.ask_definition()
    -- end)
    -- vim.keymap.set("n", "<leader>D", function()
    --   otter.ask_type_definition()
    -- end)
    -- vim.keymap.set("n", "K", function()
    --   otter.ask_hover()
    -- end)
    -- vim.keymap.set("n", "gr", function()
    --   otter.ask_references()
    -- end)
    -- vim.keymap.set("n", "<leader>rn", function()
    --   otter.ask_rename()
    -- end)
    -- vim.keymap.set("n", "<leader>f", function()
    --   otter.ask_format()
    -- end)
  end,
}
