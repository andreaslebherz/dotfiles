return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil = require("oil")
    oil.setup({
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, "..")
        end,
      },
      keymaps = {
        ["<CR>"] = "actions.select",
        ["-"] = "actions.parent",
        ["q"] = "actions.close",
        
        -- Disable C-p to overwrite as global Telescope works
        ["<C-p>"] = false, 
        -- Re-map preview to 'K' (standard Vim for 'hover/info')
        ["K"] = "actions.preview",
        -- Find files in current directory
        ["<leader>ff"] = function()
          local current_dir = oil.get_current_dir()
          require("telescope.builtin").find_files({
            cwd = current_dir,
            hidden = true,
            no_ignore = false,
          })
        end,
        -- Live grep in current directory
        ["<leader>fg"] = function()
          require("telescope.builtin").live_grep({
            cwd = oil.get_current_dir(),
          })
        end,
      },
    })

    -- The magic toggle
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}
