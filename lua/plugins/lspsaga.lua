return {
  "glepnir/lspsaga.nvim", -- LSP UIs
  event = "LspAttach",
  config = function()
    local saga = require "lspsaga"

    saga.setup {
      server_filetype_map = {},
      lightbulb = {
        enable = false,
        enable_in_insert = true,
        sign = true,
        sign_priority = 40,
        virtual_text = false,
      },
      symbol_in_winbar = {
        enable = false,
        separator = " > ",
        hide_keyword = true,
        show_file = true,
        folder_level = 1,
        respect_root = false,
        color_mode = true,
      },
      ui = {
        kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
      },
    }

    local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "<leader>j", "<Cmd>Lspsaga diagnostic_jump_next<cr>", opts)
    vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<cr>", opts)
    vim.keymap.set("n", "<leader>gd", "<Cmd>Lspsaga lsp_finder<cr>", opts)
    vim.keymap.set("n", "<leader>gp", "<Cmd>Lspsaga peek_definition<cr>", opts)
    vim.keymap.set("n", "<leader>gr", "<Cmd>Lspsaga rename<cr>", opts)
    -- Show line diagnostics
    vim.keymap.set("n", "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
    -- Code action
    vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
  end,
}
