local status, ts = pcall(require, 'nvim-treesitter.configs')
if (not status) then return end

ts.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {}
  },
  ensure_installed = {
    'tsx',
    'lua',
    'json',
    'javascript',
    'typescript',
    'html',
    'css',
    'python'
  },
  autotag = {
    enable = true
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  }
}
