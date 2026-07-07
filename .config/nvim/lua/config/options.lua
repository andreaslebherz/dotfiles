local opt = vim.opt

-- Line Numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8

-- Cursor in builtin terminal
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkon0"

-- Auto-reload files changed on disk. The agent writes in a separate process,
-- so without this nvim keeps a stale buffer and gitsigns a stale diff.
opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Recompute git signs once an external change has been pulled in.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    pcall(function()
      require("gitsigns").refresh()
    end)
  end,
})

-- Harpoon's select() calls bufload(), which cannot answer the interactive E325
-- swap-file prompt and throws. Suppress the ATTENTION message (shortmess "A")
-- and auto-choose "edit anyway" so the file just opens.
-- Caveat: does not stop two nvim instances editing the same file concurrently.
opt.shortmess:append("A")
vim.api.nvim_create_autocmd("SwapExists", {
  callback = function()
    vim.v.swapchoice = "e"
  end,
})
