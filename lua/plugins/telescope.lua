return {
  "nvim-telescope/telescope.nvim",
  event = "UIEnter",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-lua/popup.nvim" },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      dependencies = {
        "junegunn/fzf.vim",
        dependencies = {
          {
            "tpope/vim-dispatch",
            cmd = { "Make", "Dispatch" },
          },
        },
      },
    },
    -- { "nvim-telescope/telescope-file-browser.nvim" },
    { "nvim-tree/nvim-web-devicons" },
  },
  config = function()
    require "sixzen.telescope.setup"
    require "sixzen.telescope.mappings"
  end,
}
