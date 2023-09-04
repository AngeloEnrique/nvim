return {
  "neovim/nvim-lspconfig", -- LSP
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "SmiteshP/nvim-navic",             -- Breadcrumb
    "jose-elias-alvarez/null-ls.nvim", -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
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
    --   "lvimuser/lsp-inlayhints.nvim",
    --   config = function()
    --     require("lsp-inlayhints").setup()
    --     vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
    --     vim.api.nvim_create_autocmd("LspAttach", {
    --       group = "LspAttach_inlayhints",
    --       callback = function(args)
    --         if not (args.data and args.data.client_id) then
    --           return
    --         end
    --
    --         local bufnr = args.buf
    --         local client = vim.lsp.get_client_by_id(args.data.client_id)
    --         require("lsp-inlayhints").on_attach(client, bufnr, false)
    --       end,
    --     })
    --   end,
    -- },
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
  config = function()
    require "sixzen.lsp.servers"
    require "sixzen.lsp.mapping"
  end,
}
