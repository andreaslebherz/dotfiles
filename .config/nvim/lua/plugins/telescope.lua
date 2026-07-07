return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-tree/nvim-web-devicons", enabled = true },
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local lga_actions = require("telescope-live-grep-args.actions")

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
      extensions = {
        live_grep_args = {
          -- <C-k>/<C-j> are taken by result nav above; quote_prompt goes on <C-g> instead
          mappings = {
            i = {
              ["<C-g>"] = lga_actions.quote_prompt(),
            },
          },
        },
      },
    })
    telescope.load_extension("live_grep_args")

    -- Set keymaps
    local keymap = vim.keymap

    -- VS Code style Ctrl+P (hidden=true so files under .config/ are visible)
    keymap.set("n", "<C-p>", "<cmd>Telescope find_files hidden=true<cr>", { desc = "Fuzzy find files" })

    -- Grep (Search string in project)
    keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep_args<cr>", { desc = "Find string in cwd" })

    -- Jump between open buffers
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find open buffers" })
    
    -- Find string under cursor (Super useful for C++)
    keymap.set("n", "<leader>fc", function()
      require("telescope").extensions.live_grep_args.live_grep_args({
        default_text = '"' .. vim.fn.expand("<cword>") .. '" ',
      })
    end, { desc = "Find string under cursor" })
  end,
}
