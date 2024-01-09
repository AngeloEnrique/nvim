return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "saadparwaiz1/cmp_luasnip",            --cmp luasnip
    "hrsh7th/cmp-path",                    -- nvim-cmp buffer for paths
    "hrsh7th/cmp-buffer",                  -- nvim-cmp source for buffer words
    "hrsh7th/cmp-nvim-lsp",                -- nvim-cmp source for neovim',s built-in LSP
    "hrsh7th/cmp-nvim-lua",                -- nvim-cmp for lua
    "hrsh7th/cmp-git",                     -- nvim-cmp for git
    "hrsh7th/cmp-cmdline",                 -- nvim-cmp for cmdline
    -- "hrsh7th/cmp-nvim-lsp-signature-help", -- nvim-cmp for cmdline
    "L3MON4D3/LuaSnip",                    -- Snippets
    -- "zbirenbaum/copilot-cmp",              -- Copilot
    -- "windwp/nvim-autopairs",
    "roobert/tailwindcss-colorizer-cmp.nvim",
  },
  event = { "InsertEnter", "CmdlineEnter" },
  config = function()
    local cmp = require "cmp"
    -- local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    local cmp_window = require "cmp.config.window"
    local cmp_mapping = require "cmp.config.mapping"
    local icons = require "sixzen.icons"

    -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    local cmp_types = require "cmp.types.cmp"
    local ConfirmBehavior = cmp_types.ConfirmBehavior
    local SelectBehavior = cmp_types.SelectBehavior
    local luasnip = require "luasnip"
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
          luasnip.filetype_extend("javascript", { "javascriptreact" })
        end,
      },
      experimental = {
        native_menu = false,
        ghost_text = false,
      },
      window = {
        completion = cmp_window.bordered(),
        documentation = cmp_window.bordered(),
      },
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,

          -- copied from cmp-under, but I don't think I need the plugin for this.
          -- I might add some more of my own.
          function(entry1, entry2)
            local _, entry1_under = entry1.completion_item.label:find "^_+"
            local _, entry2_under = entry2.completion_item.label:find "^_+"
            entry1_under = entry1_under or 0
            entry2_under = entry2_under or 0
            if entry1_under > entry2_under then
              return false
            elseif entry1_under < entry2_under then
              return true
            end
          end,

          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      mapping = cmp_mapping.preset.insert {
        ["<Down>"] = cmp_mapping(cmp_mapping.select_next_item { behavior = SelectBehavior.Select }, { "i" }),
        ["<Up>"] = cmp_mapping(cmp_mapping.select_prev_item { behavior = SelectBehavior.Select }, { "i" }),
        ["<C-d>"] = cmp_mapping.scroll_docs(-4),
        ["<C-u>"] = cmp_mapping.scroll_docs(4),
        ["<C-y>"] = cmp_mapping {
          i = cmp_mapping.confirm { behavior = ConfirmBehavior.Insert, select = true },
          c = function(fallback)
            if cmp.visible() then
              cmp.confirm { behavior = ConfirmBehavior.Insert, select = true }
            else
              fallback()
            end
          end,
        },
        ["<C-n>"] = cmp_mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item { behavior = SelectBehavior.Select }
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-p>"] = cmp_mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item { behavior = SelectBehavior.Select }
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-Space>"] = cmp_mapping.complete(),
        ["<C-e>"] = cmp_mapping.abort(),
      },
      sources = cmp.config.sources {
        -- {
        --   name = "copilot",
        --   keyword_length = 0,
        --   max_item_count = 3,
        -- },
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        -- { name = "nvim_lsp_signature_help" },
        {
          name = "buffer",
          keyword_length = 4,
          option = {
            get_bufnrs = function()
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
        { name = "path" },
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        max_width = 0,
        kind_icons = icons.kind,
        source_names = {
          nvim_lsp = "(LSP)",
          emoji = "(Emoji)",
          path = "(Path)",
          calc = "(Calc)",
          cmp_tabnine = "(Tabnine)",
          vsnip = "(Snippet)",
          luasnip = "(Snippet)",
          buffer = "(Buffer)",
          tmux = "(TMUX)",
          copilot = "(Copilot)",
          treesitter = "(TreeSitter)",
          neorg = "(Neorg)",
        },
        duplicates = {
          buffer = 1,
          path = 1,
          nvim_lsp = 0,
          luasnip = 1,
        },
        duplicates_default = 0,
        format = function(entry, vim_item)
          local max_width = 0
          if max_width ~= 0 and #vim_item.abbr > max_width then
            vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
          end

          vim_item.kind = icons.kind[vim_item.kind]

          if entry.source.name == "copilot" then
            vim_item.kind = icons.git.Octoface
            vim_item.kind_hl_group = "CmpItemKindCopilot"
          end

          if entry.source.name == "cmp_tabnine" then
            vim_item.kind = icons.misc.Robot
            vim_item.kind_hl_group = "CmpItemKindTabnine"
          end

          if entry.source.name == "crates" then
            vim_item.kind = icons.misc.Package
            vim_item.kind_hl_group = "CmpItemKindCrate"
          end

          if entry.source.name == "lab.quick_data" then
            vim_item.kind = icons.misc.CircuitBoard
            vim_item.kind_hl_group = "CmpItemKindConstant"
          end

          if entry.source.name == "emoji" then
            vim_item.kind = icons.misc.Smiley
            vim_item.kind_hl_group = "CmpItemKindEmoji"
          end
          local source_names = {
            nvim_lsp = "(LSP)",
            emoji = "(Emoji)",
            path = "(Path)",
            calc = "(Calc)",
            cmp_tabnine = "(Tabnine)",
            vsnip = "(Snippet)",
            luasnip = "(Snippet)",
            buffer = "(Buffer)",
            tmux = "(TMUX)",
            copilot = "(Copilot)",
            treesitter = "(TreeSitter)",
            neorg = "(Neorg)",
          }
          local duplicates = {
            buffer = 1,
            path = 1,
            nvim_lsp = 0,
            luasnip = 1,
          }
          vim_item.menu = source_names[entry.source.name]
          vim_item.dup = duplicates[entry.source.name] or 0
          if vim.tbl_contains({ "nvim_lsp" }, entry.source.name) then
            local words = {}
            for word in string.gmatch(vim_item.word, "[^-]+") do
              table.insert(words, word)
            end

            local color_name, color_number
            if
                words[2] == "x"
                or words[2] == "y"
                or words[2] == "t"
                or words[2] == "b"
                or words[2] == "l"
                or words[2] == "r"
            then
              color_name = words[3]
              color_number = words[4]
            else
              color_name = words[2]
              color_number = words[3]
            end

            if color_name == "white" or color_name == "black" then
              local color
              if color_name == "white" then
                color = "ffffff"
              else
                color = "000000"
              end

              local hl_group = "lsp_documentColor_mf_" .. color
              vim.api.nvim_set_hl(0, hl_group, { fg = "#" .. color, bg = "#" .. color })
              vim_item.kind_hl_group = hl_group

              -- make the color square 2 chars wide
              vim_item.kind = string.rep("X", 2)

              return vim_item
            elseif #words < 3 or #words > 4 then
              -- doesn't look like this is a tailwind css color
              return vim_item
            end

            if not color_name or not color_number then
              return vim_item
            end

            local color_index = tonumber(color_number)
            local tailwindcss_colors = require("tailwindcss-colorizer-cmp.colors").TailwindcssColors

            if not tailwindcss_colors[color_name] then
              return vim_item
            end

            if not tailwindcss_colors[color_name][color_index] then
              return vim_item
            end

            local color = tailwindcss_colors[color_name][color_index]

            local hl_group = "lsp_documentColor_mf_" .. color
            vim.api.nvim_set_hl(0, hl_group, { fg = "#" .. color, bg = "#" .. color })

            vim_item.kind_hl_group = hl_group

            -- make the color square 2 chars wide
            vim_item.kind = string.rep("X", 2)

            return vim_item
          end
          return vim_item
        end,
      },
    }

    -- Set configuration for specific filetype.
    cmp.setup.filetype("gitcommit", {
      sources = cmp.config.sources({
        { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
      }, {
        { name = "buffer" },
      }),
    })

    cmp.setup.filetype("norg", {
      sources = cmp.config.sources({
        { name = "neorg" },
      }, {
        { name = "buffer" },
      }),
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
      sources = cmp.config.sources({
        { name = "vim-dadbod-completion" },
      }, {
        { name = "buffer" },
      }),
    })

    vim.api.nvim_set_hl(0, "CmpItemKind", { link = "CmpItemMenuDefault" })
  end,
}
