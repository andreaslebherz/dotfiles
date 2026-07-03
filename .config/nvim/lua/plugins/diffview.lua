return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
    { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Diffview close" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
  },
  config = function()
    local actions = require("diffview.actions")
    require("diffview").setup({
      keymaps = {
        -- ä/ö for next/prev instead of ]c/[c and Tab: brackets need AltGr on a
        -- German layout. ä = forward, ö = back, everywhere in Diffview.
        view = {
          { "n", "ä", "]c", { desc = "Next change" } },
          { "n", "ö", "[c", { desc = "Prev change" } },
        },
        file_panel = {
          { "n", "ä", actions.select_next_entry, { desc = "Next file" } },
          { "n", "ö", actions.select_prev_entry, { desc = "Prev file" } },
        },
      },
    })
  end,
}
