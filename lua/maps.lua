local keymap = vim.keymap

keymap.set("n", "<Space>", "", {})
vim.g.mapleader = " "
keymap.set("n", "<BS>", "", {})
vim.g.maplocalleader = vim.api.nvim_replace_termcodes("<BS>", false, false, true)

-- Exit and save
-- keymap.set("n", "<leader>q", ":q<Return>", { silent = true })
-- keymap.set("n", "<leader>Q", ":q!<Return>", { silent = true })
-- keymap.set("n", "<leader>w", ":w<Return>", { silent = true })

-- Movements
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Blazing fast replace a word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- format
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Do not yank with x
keymap.set("n", "x", '"_x')

-- Increment/Decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Paste without yank.
keymap.set("v", "<leader>p", '"_dP')

-- Indent
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Delete a word backwards
-- keymap.set("n", "dw", 'vb"_d')

-- Select all
-- keymap.set("n", "<C-a>", "gg<S-v>G")

-- New tab
keymap.set("n", "<leader>te", ":tabedit<Return>", { silent = true })
-- Split window
keymap.set("n", "<leader>ss", ":split<Return><C-w>w", { silent = true })
keymap.set("n", "<leader>sv", ":vsplit<Return><C-w>w", { silent = true })
-- Move window (now using tmux plugin)
keymap.set("n", "<leader><Tab>", "<C-w>w")
-- keymap.set("", "s<left>", "<C-w>h")
-- keymap.set("", "s<up>", "<C-w>k")
-- keymap.set("", "s<down>", "<C-w>j")
-- keymap.set("", "s<right>", "<C-w>l")
-- keymap.set("", "sh", "<C-w>h")
-- keymap.set("", "sk", "<C-w>k")
-- keymap.set("", "sj", "<C-w>j")
-- keymap.set("", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<leader><left>", "5<C-w><")
keymap.set("n", "<leader><right>", "5<C-w>>")
keymap.set("n", "<leader><up>", "3<C-w>+")
keymap.set("n", "<leader><down>", "3<C-w>-")

-- Move lines
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

keymap.set("n", "<leader>x", ":lua require'utils'.buf_kill('bd', 0, false) <CR>", { silent = true })
