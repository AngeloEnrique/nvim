return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  keys = {
    { "<leader>no", "<cmd>Neorg index<cr>", desc = "Neorg" },
  },
  cmd = { "Neorg" },
  dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-treesitter/nvim-treesitter" } },
  opts = {
    load = {
      ["core.defaults"] = {},       -- Loads default behaviour
      ["core.concealer"] = {}, -- Adds pretty icons to your documents
      ["core.dirman"] = {      -- Manages Neorg workspaces
        config = {
          workspaces = {
            notes = "~/notes",
          },
          default_workspace = "notes",
        },
      },
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },
    },
  },
}
