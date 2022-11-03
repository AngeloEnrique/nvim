vim.cmd('autocmd!')


vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.wo.number = true
vim.opt.relativenumber = true

vim.opt.completeopt = { "menuone", "noselect" }

vim.opt.guifont = 'monospace:h14'
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.conceallevel = 0
vim.opt.hidden = true
vim.opt.pumheight = 10
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.timeoutlen = 1000
vim.opt.updatetime = 100
vim.opt.writebackup = false
vim.opt.signcolumn = 'yes'
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.shell = 'zsh'
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.mouse = 'a'
vim.opt.tabstop = 2
vim.opt.laststatus = 3 -- always show status line
vim.opt.ai = true -- Auto Indent
vim.opt.si = true -- Smart Indent
vim.opt.wrap = false -- No Wrap Lines
vim.opt.undofile = true
vim.opt.backspace = 'start,eol,indent'
vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.spelllang:append "cjk" -- disable spellchecking for asian characters (VIM algorithm does not support it)
vim.opt.shortmess:append "c" -- don't show redundant messages from ins-completion-menu
vim.opt.shortmess:append "I" -- don't show the default intro message
vim.opt.whichwrap:append "<,>,[,],h,l"

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
-- doesn't work on iTerm2

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = '*',
  command = "set nopaste"
})

vim.opt.formatoptions:append { 'r' }

-- Change Github Copilot nodejs version to work
vim.g.copilot_node_command = "~/.nvm/versions/node/v16.17.1/bin/node"
