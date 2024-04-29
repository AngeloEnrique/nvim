return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "SirZenith/oil-vcs-status" },
  config = function()
    require("oil").setup {
      skip_confirm_for_simple_edits = true,
      win_options = {
        signcolumn = "yes:2",
      },
      view_options = {
        show_hidden = true,
      },
    }
    local status_const = require "oil-vcs-status.constant.status"

    local StatusType = status_const.StatusType

    require("oil-vcs-status").setup {
      fs_event_debounce = 500,
      vcs_specific = {
        git = {
          status_update_debounce = 200,
        },
      },
      status_priority = {
        [StatusType.UpstreamIgnored] = 0,
        [StatusType.UpstreamUntracked] = 1,
        [StatusType.UpstreamUnmodified] = 2,

        [StatusType.UpstreamCopied] = 3,
        [StatusType.UpstreamRenamed] = 3,
        [StatusType.UpstreamTypeChanged] = 3,

        [StatusType.UpstreamDeleted] = 4,
        [StatusType.UpstreamModified] = 4,
        [StatusType.UpstreamAdded] = 4,

        [StatusType.UpstreamUnmerged] = 5,

        [StatusType.Ignored] = 10,
        [StatusType.Untracked] = 11,
        [StatusType.Unmodified] = 12,

        [StatusType.Copied] = 13,
        [StatusType.Renamed] = 13,
        [StatusType.TypeChanged] = 13,

        [StatusType.Deleted] = 14,
        [StatusType.Modified] = 14,
        [StatusType.Added] = 14,

        [StatusType.Unmerged] = 15,
      },
      status_symbol = {
        [StatusType.Added] = "",
        [StatusType.Copied] = "󰆏",
        [StatusType.Deleted] = "",
        [StatusType.Ignored] = "",
        [StatusType.Modified] = "",
        [StatusType.Renamed] = "",
        [StatusType.TypeChanged] = "󰉺",
        [StatusType.Unmodified] = " ",
        [StatusType.Unmerged] = "",
        [StatusType.Untracked] = "",
        [StatusType.External] = "",

        [StatusType.UpstreamAdded] = "󰈞",
        [StatusType.UpstreamCopied] = "󰈢",
        [StatusType.UpstreamDeleted] = "",
        [StatusType.UpstreamIgnored] = " ",
        [StatusType.UpstreamModified] = "󰏫",
        [StatusType.UpstreamRenamed] = "",
        [StatusType.UpstreamTypeChanged] = "󱧶",
        [StatusType.UpstreamUnmodified] = " ",
        [StatusType.UpstreamUnmerged] = "",
        [StatusType.UpstreamUntracked] = " ",
        [StatusType.UpstreamExternal] = "",
      },
    }
    vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}
