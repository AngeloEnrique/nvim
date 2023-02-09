return {
  { "kyazdani42/nvim-web-devicons", config = {
    override = {},
    default = true,
  } }, -- File icons

  "github/copilot.vim", -- Github Copilot

  { "windwp/nvim-autopairs", config = {
    disable_filetype = { "TelescopePrompt", "vim" },
  } },
  { "windwp/nvim-ts-autotag", config = true },

  "SmiteshP/nvim-navic", -- Breadcrumb
  { "norcalli/nvim-colorizer.lua", config = {
    "*",
  } },
}
