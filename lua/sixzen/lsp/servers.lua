local status, nvim_lsp = pcall(require, "lspconfig")

if not status then
  return
end

local util = require "lspconfig.util"
local on_attach = require("sixzen.lsp").on_attach
local capabilities = require("sixzen.lsp").capabilities()
local python_capabilities = capabilities
if python_capabilities.workspace == nil then
  python_capabilities.workspace = {}
  python_capabilities.workspace.didChangeWatchedFiles = {}
end
python_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

-- local function get_quarto_resource_path()
--   local function strsplit(s, delimiter)
--     local result = {}
--     for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
--       table.insert(result, match)
--     end
--     return result
--   end
--
--   local f = assert(io.popen("quarto --paths", "r"))
--   local s = assert(f:read "*a")
--   f:close()
--   return strsplit(s, "\n")[2]
-- end
--
-- local lua_library_files = vim.api.nvim_get_runtime_file("", true)
-- local lua_plugin_paths = {}
-- local resource_path = get_quarto_resource_path()
-- if resource_path == nil then
--   vim.notify_once "quarto not found, lua library files not loaded"
-- else
--   table.insert(lua_library_files, resource_path .. "/lua-types")
--   table.insert(lua_plugin_paths, resource_path .. "/lua-plugin/plugin.lua")
-- end

local servers = {
  ["pyright"] = function()
    return {
      on_attach = on_attach,
      capabilities = python_capabilities,
      settings = {
        pyright = {
          disableLanguageServices = false,
          disableOrganizeImports = false,
        },
        python = {
          analysis = {
            autoImportCompletions = true,
            autoSearchPaths = true,
            diagnosticMode = "workspace", -- openFilesOnly, workspace
            -- typeCheckingMode = "basic",   -- off, basic, strict
            useLibraryCodeForTypes = true,
          },
        },
      },
      root_dir = function(fname)
        return util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt")(fname)
            or util.path.dirname(fname)
      end,
    }
  end,
  ["marksman"] = function()
    return {
      capabilities = capabilities,
      filetypes = { "markdown", "quarto" },
      root_dir = util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
    }
  end,
  -- ["jdtls"] = function()
  --   return {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --   }
  -- end,
  ["r_language_server"] = function()
    return {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        r = {
          lsp = {
            rich_documentation = false,
          },
        },
      },
    }
  end,
  ["eslint"] = function()
    return {
      on_attach = on_attach,
    }
  end,
  ["dotls"] = function()
    return {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ["dockerls"] = function()
    return {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ["rust_analyzer"] = function()
    return {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ["lemminx"] = function()
    return {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ["yamlls"] = function()
    return {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ["emmet_ls"] = function()
    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
    return {
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
  end,
  ["gopls"] = function()
    return {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
        },
      },
    }
  end,
  ["cssls"] = function()
    return {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ["tailwindcss"] = function()
    return {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ["html"] = function()
    return {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ["jsonls"] = function()
    return {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  -- ["lua_ls"] = function()
  --   return {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --     settings = {
  --       Lua = {
  --         completion = {
  --           callSnippet = "Replace",
  --         },
  --         runtime = {
  --           version = "LuaJIT",
  --           plugin = lua_plugin_paths,
  --         },
  --         diagnostics = {
  --           globals = { "vim", "quarto", "pandoc", "io", "string", "print", "require", "table" },
  --           disable = { "trailing-space" },
  --         },
  --         workspace = {
  --           library = lua_library_files,
  --           checkThirdParty = false,
  --         },
  --         telemetry = {
  --           enable = false,
  --         },
  --       },
  --     },
  --   }
  -- end,
  ["lua_ls"] = function()
    return {
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
  end,
  -- ["tsserver"] = function()
  --   return {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --     filetypes = {
  --       "javascript",
  --       "javascriptreact",
  --       "javascript.jsx",
  --       "typescript",
  --       "typescriptreact",
  --       "typescript.tsx",
  --     },
  --     cmd = { "typescript-language-server", "--stdio" },
  --     settings = {
  --       typescript = {
  --         inlayHints = {
  --           includeInlayParameterNameHints = "all",
  --           includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  --           includeInlayFunctionParameterTypeHints = true,
  --           includeInlayVariableTypeHints = true,
  --           includeInlayPropertyDeclarationTypeHints = true,
  --           includeInlayFunctionLikeReturnTypeHints = true,
  --           includeInlayEnumMemberValueHints = true,
  --         },
  --       },
  --       javascript = {
  --         inlayHints = {
  --           includeInlayParameterNameHints = "all",
  --           includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  --           includeInlayFunctionParameterTypeHints = true,
  --           includeInlayVariableTypeHints = true,
  --           includeInlayPropertyDeclarationTypeHints = true,
  --           includeInlayFunctionLikeReturnTypeHints = true,
  --           includeInlayEnumMemberValueHints = true,
  --         },
  --       },
  --     },
  --   }
  -- end,
}

for server, setup in pairs(servers) do
  nvim_lsp[server].setup(setup())
end
