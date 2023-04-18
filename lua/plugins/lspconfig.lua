return {
  "neovim/nvim-lspconfig", -- LSP
  event = "BufRead",
  dependencies = {
    "SmiteshP/nvim-navic",             -- Breadcrumb
    "mfussenegger/nvim-jdtls",         -- Java stuffs
    "jose-elias-alvarez/null-ls.nvim", -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    {
      "jose-elias-alvarez/typescript.nvim",
    },
    {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()

        local opts = { noremap = true, silent = true }
        vim.keymap.set(
          "",
          "<leader>ls",
          require("lsp_lines").toggle,
          opts
        )
      end,
    },
    {
      "lvimuser/lsp-inlayhints.nvim",
      config = function()
        require("lsp-inlayhints").setup()
        vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
        vim.api.nvim_create_autocmd("LspAttach", {
          group = "LspAttach_inlayhints",
          callback = function(args)
            if not (args.data and args.data.client_id) then
              return
            end

            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            require("lsp-inlayhints").on_attach(client, bufnr, false)
          end,
        })
      end,
    },
    {
      "j-hui/fidget.nvim", -- LSP progress
      opts = {
        sources = {
          ["null-ls"] = {
            ignore = true,
          },
        },
        text = {
          spinner = "circle_halves",
        },
        window = {
          blend = 0,
          border = "rounded",
          relative = "editor",
        },
      },
    },
  },
  config = function()
    local status, nvim_lsp = pcall(require, "lspconfig")
    if not status then
      return
    end
    local status2, navic = pcall(require, "nvim-navic")

    local FORMAT_ON_SAVE = false

    local JAVA_DAP_ACTIVE = true
    -- local protocol = require "vim.lsp.protocol"
    local lsp_formatting = function(bufnr)
      vim.lsp.buf.format {
        filter = function(client)
          -- apply whatever logic you want (in this example, we'll only use null-ls)
          return client.name == "null-ls"
        end,
        bufnr = bufnr,
      }
    end

    -- if you want to set up formatting on save, you can use this as a callback
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    local on_attach = function(client, bufnr)
      if client.server_capabilities.documentSymbolProvider and status2 then
        navic.attach(client, bufnr)
      end
      if client.name == "tsserver" then
        client.server_capabilities.document_formatting = false
      end
      if client.name == "jdt.ls" then
        if JAVA_DAP_ACTIVE then
          require("jdtls").setup_dap()
          require("jdtls.dap").setup_dap_main_class_configs()
        end
        client.server_capabilities.document_formatting = false
      end
      if client.name == "eslint" then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end
      if client.supports_method "textDocument/formatting" then
        if FORMAT_ON_SAVE then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              lsp_formatting(bufnr)
            end,
          })
        end
      end
    end

    nvim_lsp.pyright.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "off",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    }

    nvim_lsp.eslint.setup {
      on_attach = on_attach,
    }

    nvim_lsp.rust_analyzer.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
    require("typescript").setup {
      disable_commands = false, -- prevent the plugin from creating Vim commands
      debug = false,            -- enable debug logging for commands
      go_to_source_definition = {
        fallback = true,        -- fall back to standard LSP definition on failure
      },
      server = {
        -- pass options to lspconfig's setup method
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        cmd = { "typescript-language-server", "--stdio" },
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      },
    }
    -- nvim_lsp.tsserver.setup {
    --   on_attach = on_attach,
    --   capabilities = capabilities,
    --   filetypes = {
    --     "javascript",
    --     "javascriptreact",
    --     "javascript.jsx",
    --     "typescript",
    --     "typescriptreact",
    --     "typescript.tsx",
    --   },
    --   cmd = { "typescript-language-server", "--stdio" },
    --   settings = {
    --     typescript = {
    --       inlayHints = {
    --         includeInlayParameterNameHints = "all",
    --         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    --         includeInlayFunctionParameterTypeHints = true,
    --         includeInlayVariableTypeHints = true,
    --         includeInlayPropertyDeclarationTypeHints = true,
    --         includeInlayFunctionLikeReturnTypeHints = true,
    --         includeInlayEnumMemberValueHints = true,
    --       },
    --     },
    --     javascript = {
    --       inlayHints = {
    --         includeInlayParameterNameHints = "all",
    --         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    --         includeInlayFunctionParameterTypeHints = true,
    --         includeInlayVariableTypeHints = true,
    --         includeInlayPropertyDeclarationTypeHints = true,
    --         includeInlayFunctionLikeReturnTypeHints = true,
    --         includeInlayEnumMemberValueHints = true,
    --       },
    --     },
    --   },
    -- }

    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
    nvim_lsp.emmet_ls.setup {
      on_attach = on_attach,
      capabilities = cmp_capabilities,
      filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "css",
        "sass",
        "scss",
        "less",
      },
    }

    nvim_lsp.tailwindcss.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    nvim_lsp.html.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    nvim_lsp.jsonls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    nvim_lsp.lua_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          runtime = {
            version = "LuaJIT",
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
          hint = {
            enable = true,
          },
        },
      },
    }

    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- vim.diagnostic.config {
    --   virtual_text = {
    --     prefix = "●",
    --   },
    --   update_in_insert = true,
    --   float = {
    --     source = "always", -- Or "if_many"
    --   },
    -- }

    vim.diagnostic.config {
      virtual_text = false,
      update_in_insert = true,
      virtual_lines = true,
      float = {
        source = "always", -- Or "if_many"
      },
    }

    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    vim.keymap.set("n", "<leader>gK", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  end,
}
