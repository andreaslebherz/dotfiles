return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true, -- Crucial for seeing .config, .git, etc.
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, "..") -- Hide the '..' to keep it clean
        end,
      },
      keymaps = {
        ["<CR>"] = "actions.select",
        ["-"] = "actions.parent",
        ["q"] = "actions.close", -- Press q to jump back to your code
        ["<C-p>"] = "actions.preview", -- Preview the file under cursor in a popup
        ["<leader>ff"] = function()
          local current_dir = require("oil").get_current_dir()
          require("telescope.builtin").find_files({
            cwd = current_dir,
            hidden = true,
            no_ignore = false,
          })
        end,
        ["<leader>fg"] = function()
          require("telescope.builtin").live_grep({
            cwd = require("oil").get_current_dir(),
          })
        end,
      },
    })

    -- The magic toggle
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}
