return {
  "neovim/nvim-lspconfig", -- LSP
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "SmiteshP/nvim-navic", -- Breadcrumb
    "nvimtools/none-ls.nvim",
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    {
      "jose-elias-alvarez/typescript.nvim",
    },
    {
      "antosha417/nvim-lsp-file-operations",
      config = true,
    },
    {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()

        local opts = { noremap = true, silent = true }
        vim.keymap.set("", "<leader>ls", require("lsp_lines").toggle, opts)
      end,
    },
    -- {
    --   "j-hui/fidget.nvim", -- LSP progress
    --   opts = {
    --     sources = {
    --       ["null-ls"] = {
    --         ignore = true,
    --       },
    --     },
    --     text = {
    --       spinner = "circle_halves",
    --     },
    --     window = {
    --       blend = 0,
    --       border = "rounded",
    --       relative = "editor",
    --     },
    --   },
    -- },
  },
  main = "sixzen.lsp",
  config = true,
}
