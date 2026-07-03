return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    local keymap = vim.keymap

    -- Pin current file
    keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "Harpoon add file" })

    -- Toggle quick menu
    keymap.set("n", "<leader>h", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon menu" })

    -- Jump to pinned slots
    for i = 1, 4 do
      keymap.set("n", "<leader>" .. i, function()
        harpoon:list():select(i)
      end, { desc = "Harpoon slot " .. i })
    end

    -- Cycle through the list
    keymap.set("n", "<C-S-p>", function()
      harpoon:list():prev()
    end, { desc = "Harpoon prev" })
    keymap.set("n", "<C-S-n>", function()
      harpoon:list():next()
    end, { desc = "Harpoon next" })

    -- Reorder lines inside the quick menu (global "_dd shadowed here)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "harpoon",
      callback = function(ev)
        local opts = { buffer = ev.buf }
        keymap.set("n", "<A-j>", ":m +1<CR>", opts)
        keymap.set("n", "<A-k>", ":m -2<CR>", opts)
        keymap.set("n", "dd", "dd", opts)
      end,
    })
  end,
}
