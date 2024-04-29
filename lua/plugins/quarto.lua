return {

  { -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
    -- for complete functionality (language features)
    "quarto-dev/quarto-nvim",
    ft = { "quarto" },
    config = function()
      local quarto = require "quarto"

      quarto.setup {
        lspFeatures = {
          languages = { "r", "python", "julia", "bash", "lua", "html", "dot", "javascript", "typescript", "ojs" },
        },
        codeRunner = {
          enabled = true,
          default_method = "slime",
        },
        keymap = {
          hover = "K",
          definition = "gd",
          type_definition = "<leader>D",
          rename = "<leader>rn",
          format = "<leader>f",
          references = "gr",
          document_symbols = false,
        },
      }

      local is_code_chunk = function()
        local current, _ = require("otter.keeper").get_current_language_context()
        if current then
          return true
        else
          return false
        end
      end

      --- Insert code chunk of given language
      --- Splits current chunk if already within a chunk
      --- @param lang string
      local insert_code_chunk = function(lang)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
        local keys
        if is_code_chunk() then
          keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
        else
          keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
        end
        keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
        vim.api.nvim_feedkeys(keys, "n", false)
      end

      -- local insert_r_chunk = function()
      --   insert_code_chunk "r"
      -- end

      local insert_py_chunk = function()
        insert_code_chunk "python"
      end

      -- local insert_lua_chunk = function()
      --   insert_code_chunk "lua"
      -- end
      --
      -- local insert_julia_chunk = function()
      --   insert_code_chunk "julia"
      -- end
      --
      -- local insert_bash_chunk = function()
      --   insert_code_chunk "bash"
      -- end
      --
      -- local insert_ojs_chunk = function()
      --   insert_code_chunk "ojs"
      -- end

      vim.keymap.set({ "n", "i" }, "<M-c>", insert_py_chunk)
      vim.keymap.set("n", "<leader>qp", quarto.quartoPreview, { silent = true, noremap = true })
      vim.keymap.set("n", "<leader><cr>", quarto.quartoSend, { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>qt", ":split term://ipython<cr>G<C-w>k", { silent = true, noremap = true })
      vim.cmd("TSContextDisable")
    end,
    dependencies = {
      -- for language features in code cells
      -- configured in lua/plugins/lsp.lua and
      -- added as a nvim-cmp source in lua/plugins/completion.lua
      "jmbuhr/otter.nvim",
    },
  },

  { -- directly open ipynb files as quarto docuements
    -- and convert back behind the scenes
    -- needs:
    -- pip install jupytext
    "GCBallesteros/jupytext.nvim",
    opts = {
      custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto", -- you can set whatever filetype you want here
        },
        r = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto", -- you can set whatever filetype you want here
        },
      },
    },
  },

  { -- send code from python/r/qmd documets to a terminal or REPL
    -- like ipython, R, bash
    "jpalardy/vim-slime",
    init = function()
      vim.b["quarto_is_python_chunk"] = false
      Quarto_is_in_python_chunk = function()
        require("otter.tools.functions").is_otter_language_context "python"
      end

      vim.cmd [[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
      else
      if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
      return [a:text, "\n"]
      else
      return [a:text]
      end
      end
      endfunction
      ]]

      vim.g.slime_no_mappings = 1
      vim.g.slime_target = "neovim"
      vim.g.slime_python_ipython = 1
    end,
    config = function()
      local function mark_terminal()
        vim.g.slime_last_channel = vim.b.terminal_job_id
      end

      local function set_terminal()
        vim.b.slime_config = { jobid = vim.g.slime_last_channel }
      end
      vim.keymap.set("n", "<leader>cm", mark_terminal, { desc = "[m]ark terminal" })
      vim.keymap.set("n", "<leader>cs", set_terminal, { desc = "[s]et terminal" })
    end,
  },

  { -- paste an image from the clipboard or drag-and-drop
    "HakonHarnes/img-clip.nvim",
    event = "BufEnter",
    ft = { "markdown", "quarto", "latex" },
    opts = {
      default = {
        dir_path = "img",
      },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = {
            download_images = false,
          },
        },
        quarto = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = {
            download_images = false,
          },
        },
      },
    },
    config = function(_, opts)
      require("img-clip").setup(opts)
      vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "insert [i]mage from clipboard" })
    end,
  },

  { -- preview equations
    "jbyuki/nabla.nvim",
    keys = {
      { "<leader>qm", ':lua require"nabla".toggle_virt()<cr>', desc = "toggle [m]ath equations" },
    },
  },

  -- {
  --   "benlubas/molten-nvim",
  --   enabled = false,
  --   build = ":UpdateRemotePlugins",
  --   init = function()
  --     vim.g.molten_image_provider = "image.nvim"
  --     vim.g.molten_output_win_max_height = 20
  --     vim.g.molten_auto_open_output = false
  --   end,
  --   keys = {
  --     { "<leader>mi", ":MoltenInit<cr>",           desc = "[m]olten [i]nit" },
  --     {
  --       "<leader>mv",
  --       ":<C-u>MoltenEvaluateVisual<cr>",
  --       mode = "v",
  --       desc = "molten eval visual",
  --     },
  --     { "<leader>mr", ":MoltenReevaluateCell<cr>", desc = "molten re-eval cell" },
  --   },
  -- },
}
