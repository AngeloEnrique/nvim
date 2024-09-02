local status, nvim_lsp = pcall(require, "lspconfig")

if not status then
  return
end

local util = require "lspconfig.util"
local lspUtils = require "sixzen.lsp.utils"
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
      on_attach = on_attach,
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
      filetypes = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "astro", "css" },
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
  ["vtsls"] = function()
    return {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          enableOrganizeImportsCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
          tsserver = {
            globalPlugins = {
              {
                name = "@angular/language-server",
                location = lspUtils.get_pkg_path("angular-language-server", "node_modules/@angular/language-server"),
                enableForWorkspaceTypeScriptVersions = false,
              },
            },
          },
        },
        javascript = {
          updateImportsOnFileMove = "always",
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
        typescript = {
          updateImportsOnFileMove = "always",
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    }
  end,
  ["angularls"] = function()
    local cmd = {
      "ngserver",
      "--stdio",
      "--tsProbeLocations",
      table.concat({
        lspUtils.get_pkg_path("angular-language-server", "node_modules"),
        vim.fn.getcwd() .. "/node_modules",
      }, ","),
      "--ngProbeLocations",
      table.concat({
        lspUtils.get_pkg_path("angular-language-server", "node_modules/@angular/language-server/node_modules"),
        vim.fn.getcwd() .. "/node_modules",
      }, ","),
    }

    return {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = cmd,
      on_new_config = function(new_config, new_root_dir)
        new_config.cmd = cmd
      end,
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
