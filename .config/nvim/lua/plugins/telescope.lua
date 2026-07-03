return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-tree/nvim-web-devicons", enabled = true },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        -- This repo lives under .config/ (hidden); without this, pickers can't
        -- see the dotfiles. Show hidden, but never .git internals.
        file_ignore_patterns = { "%.git/" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-e>"] = actions.select_vertical,
          },
        },
      },
    })

    -- Set keymaps
    local keymap = vim.keymap

    -- VS Code style Ctrl+P (hidden=true so files under .config/ are visible)
    keymap.set("n", "<C-p>", "<cmd>Telescope find_files hidden=true<cr>", { desc = "Fuzzy find files" })
   
    -- Grep (Search string in project)
    keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })

    -- Jump between open buffers
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find open buffers" })
    
    -- Find string under cursor (Super useful for C++)
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor" })
  end,
}
