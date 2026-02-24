-- Set <Space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

-- Fast escape
-- keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })

-- Clear search highlights
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Better window navigation
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Saving and quitting
keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Stay in indent mode
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Escape from terminal
keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, desc = "Escape from Terminal" })

-- Open Explorer
keymap.set("n", "-", "<CMD>Explore<CR>", { desc = "Open File Explorer" })

-- Normal and Visual mode: 'd' deletes to the black hole
vim.keymap.set({"n", "v"}, "d", '"_d', { desc = "Delete without copying" })
vim.keymap.set({"n", "v"}, "dd", '"_dd', { desc = "Delete line without copying" })

--- Custom vscode like terminal
local term_buf = nil
local term_win = nil

local function toggle_terminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, {force = true})
    term_win = nil
  else
    vim.cmd("botright split")
    vim.cmd("resize 15")
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
      vim.api.nvim_win_set_buf(0, term_buf)
    else
      vim.cmd("term")
      term_buf = vim.api.nvim_get_current_buf()
    end
    term_win = vim.api.nvim_get_current_win()
    vim.cmd("startinsert")
  end
end

-- Map it to Ctrl+j in Normal, Insert, and Terminal modes
keymap.set({"n", "i", "t"}, "<C-j>", toggle_terminal, { desc = "Toggle Terminal Drawer" })

-- Correct simlple typos
vim.cmd('command! Q q')
vim.cmd('command! Qa qa')
vim.cmd('command! W w')
vim.cmd('command! Wq wq')
vim.cmd('command! WQ wq')
