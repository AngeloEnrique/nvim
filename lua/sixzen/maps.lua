vim.keymap.set("n", "<Space>", "", {})
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Movements
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Blazing fast replace a word
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Do not yank with x
vim.keymap.set("n", "x", '"_x')

-- Increment/Decrement
vim.keymap.set("n", "+", "<C-a>")
vim.keymap.set("n", "-", "<C-x>")

-- Paste without yank.
-- vim.keymap.set("v", "<leader>p", '"_dp')

-- Indent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- New tab
vim.keymap.set("n", "<leader>te", ":tabedit<Return>", { silent = true })
-- Split window
-- vim.keymap.set("n", "<leader>ss", ":split<Return><C-w>w", { silent = true })
-- vim.keymap.set("n", "<leader>sv", ":vsplit<Return><C-w>w", { silent = true })
-- Move window
-- vim.keymap.set("n", "<leader><Tab>", "<C-w>w")

-- Resize window
vim.keymap.set("n", "<leader><left>", "5<C-w><")
vim.keymap.set("n", "<leader><right>", "5<C-w>>")
vim.keymap.set("n", "<leader><up>", "3<C-w>+")
vim.keymap.set("n", "<leader><down>", "3<C-w>-")

-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>x", ":lua require'sixzen.utils'.buf_kill('bd', 0, false) <CR>", { silent = true })
