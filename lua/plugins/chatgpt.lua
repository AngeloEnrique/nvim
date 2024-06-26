return {
  "jackMort/ChatGPT.nvim",
  enabled = false,
  keys = { { "<leader>c", "<cmd>ChatGPT<cr>" } },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("chatgpt").setup {
      --   welcome_message = WELCOME_MESSAGE, -- set to "" if you don't like the fancy godot robot
      --   loading_text = "loading",
      --   question_sign = "", -- you can use emoji if you want e.g. 🙂
      --   answer_sign = "󰚩", -- 🤖
      --   max_line_length = 120,
      --   yank_register = "+",
      --   chat_layout = {
      --     relative = "editor",
      --     position = "50%",
      --     size = {
      --       height = "80%",
      --       width = "80%",
      --     },
      --   },
      --   settings_window = {
      --     border = {
      --       style = "rounded",
      --       text = {
      --         top = " Settings ",
      --       },
      --     },
      --   },
      --   chat_window = {
      --     filetype = "chatgpt",
      --     border = {
      --       highlight = "FloatBorder",
      --       style = "rounded",
      --       text = {
      --         top = " ChatGPT ",
      --       },
      --     },
      --   },
      --   chat_input = {
      --     prompt = "  ",
      --     border = {
      --       highlight = "FloatBorder",
      --       style = "rounded",
      --       text = {
      --         top_align = "center",
      --         top = " Prompt ",
      --       },
      --     },
      --   },
      openai_params = {
        model = "gpt-3.5-turbo",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 1000,
        temperature = 0,
        top_p = 1,
        n = 1,
      },
      --   openai_edit_params = {
      --     model = "code-davinci-edit-001",
      --     temperature = 0,
      --     top_p = 1,
      --     n = 1,
      --   },
      keymaps = {
        close = { "<C-q>" },
        submit = "<C-e>",
        yank_last = "<C-y>",
        scroll_up = "<C-k>",
        scroll_down = "<C-j>",
        toggle_settings = "<C-o>",
        new_session = "<C-n>",
        cycle_windows = "<C-c>",
        -- in the Sessions pane
        select_session = "<S-s>",
        rename_session = "<S-r>",
        delete_session = "<S-d>",
      },
    }
  end,
}
