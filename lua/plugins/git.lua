return {
  { "lewis6991/gitsigns.nvim", event = "BufRead", config = true },
  {
    "tpope/vim-fugitive",
    event = "BufRead",
  },
  -- {
  --   "dinhhuy258/git.nvim",
  --   enabled = false,
  --   event = "BufRead",
  --   opts = {
  --     default_mappings = false,
  --     keymaps = {
  --       blame = "<Leader><Leader>gb",
  --       -- Close blame window
  --       quit_blame = "q",
  --       -- Open blame commit
  --       blame_commit = "<CR>",
  --       -- Open file/folder in git repository
  --       browse = "<Leader><Leader>go",
  --       -- Open pull request of the current branch
  --       open_pull_request = "<Leader><Leader>gp",
  --       -- Create a pull request with the target branch is set in the `target_branch` option
  --       create_pull_request = "<Leader><Leader>gn",
  --       -- Opens a new diff that compares against the current index
  --       diff = "<Leader><Leader>gd",
  --       -- Close git diff
  --       diff_close = "<Leader><Leader>gD",
  --       -- Revert to the specific commit
  --       revert = "<Leader><Leader>gr",
  --       -- Revert the current file to the specific commit
  --     },
  --   },
  -- }, -- For git blame and browse
  {
    "kdheepak/lazygit.nvim",
    keys = { { "<leader><leader>lg", "<cmd>LazyGit<CR>" } },
    config = function()
      vim.g.lazygit_floating_window_use_plenary = 1
    end,
  },
  {
    "sindrets/diffview.nvim",
    keys = { { "<leader><leader>dv", "<cmd>DiffviewOpen<CR>" } },
  },
  {
    "TimUntersberger/neogit",
    enabled = true,
    keys = { { "<leader><leader>ng", "<cmd>Neogit<CR>" } },
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
      },
    },
    opts = {
      disable_signs = false,
      disable_hint = true,
      disable_context_highlighting = false,
      disable_commit_confirmation = true,
      -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
      -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
      auto_refresh = true,
      disable_builtin_notifications = false,
      use_magit_keybindings = false,
      -- Change the default way of opening neogit
      kind = "split",
      -- Change the default way of opening the commit popup
      commit_popup = {
        kind = "split",
      },
      -- Change the default way of opening popups
      popup = {
        kind = "split",
      },
      -- customize displayed signs
      signs = {
        -- { CLOSED, OPENED }
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
      },
      integrations = {
        diffview = true,
      },
      -- Setting any section to `false` will make the section not render at all
      sections = {
        untracked = {
          folded = false,
        },
        unstaged = {
          folded = false,
        },
        staged = {
          folded = false,
        },
        stashes = {
          folded = true,
        },
        unpulled = {
          folded = true,
        },
        unmerged = {
          folded = false,
        },
        recent = {
          folded = true,
        },
      },
      -- override/add mappings
      mappings = {
        -- modify status buffer mappings
        status = {
          ["q"] = "Close",
          ["1"] = "Depth1",
          ["2"] = "Depth2",
          ["3"] = "Depth3",
          ["4"] = "Depth4",
          ["<tab>"] = "Toggle",
          ["x"] = "Discard",
          ["s"] = "Stage",
          ["a"] = "StageUnstaged",
          ["<c-s>"] = "StageAll",
          ["u"] = "Unstage",
          ["U"] = "UnstageStaged",
          ["d"] = "DiffAtFile",
          ["$"] = "CommandHistory",
          ["<c-r>"] = "RefreshBuffer",
          ["o"] = "GoToFile",
          ["<enter>"] = "Toggle",
          ["<c-v>"] = "VSplitOpen",
          ["<c-x>"] = "SplitOpen",
          ["<c-t>"] = "TabOpen",
          ["?"] = "HelpPopup",
          ["D"] = "DiffPopup",
          ["p"] = "PullPopup",
          ["r"] = "RebasePopup",
          ["P"] = "PushPopup",
          ["c"] = "CommitPopup",
          ["L"] = "LogPopup",
          ["Z"] = "StashPopup",
          ["b"] = "BranchPopup",
          -- ["<space>"] = "Stage",
          -- Removes the default mapping of "s"
          -- ["s"] = "",
        },
      },
    },
  },
}
