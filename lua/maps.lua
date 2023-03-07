local keymap = vim.keymap

keymap.set("n", "<Space>", "", {})
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Exit and save
keymap.set("n", "<leader>q", ":q<Return>", { silent = true })
keymap.set("n", "<leader>Q", ":q!<Return>", { silent = true })
keymap.set("n", "<leader>w", ":w<Return>", { silent = true })

-- Do not yank with x
keymap.set("n", "x", '"_x')

-- Increment/Decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
-- keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- New tab
keymap.set("n", "<leader>te", ":tabedit<Return>", { silent = true })
-- Split window
keymap.set("n", "<leader>ss", ":split<Return><C-w>w", { silent = true })
keymap.set("n", "<leader>sv", ":vsplit<Return><C-w>w", { silent = true })
-- Move window
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
keymap.set("n", "<leader><left>", "<C-w><")
keymap.set("n", "<leader><right>", "<C-w>>")
keymap.set("n", "<leader><up>", "<C-w>+")
keymap.set("n", "<leader><down>", "<C-w>-")

-- Move lines
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

keymap.set("n", "<leader>x", ":lua require'utils'.buf_kill('bd', 0, false) <CR>", { silent = true })

-- NvimTree
keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

-- Neogit
keymap.set("n", "<leader><leader>ng", "<cmd>Neogit<CR>")
