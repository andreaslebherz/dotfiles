return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup({
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local keymap = vim.keymap

        -- Hunk-to-hunk navigation. ä/ö instead of ]h/[h: brackets need AltGr on
        -- a German layout, and these are repeated a lot while reviewing.
        keymap.set("n", "ä", function() gs.nav_hunk("next") end, { buffer = bufnr, desc = "Next git hunk" })
        keymap.set("n", "ö", function() gs.nav_hunk("prev") end, { buffer = bufnr, desc = "Prev git hunk" })

        -- Post-apply review: stage / reset / preview individual hunks.
        keymap.set("n", "<leader>gs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
        keymap.set("n", "<leader>gr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
        keymap.set("v", "<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { buffer = bufnr, desc = "Stage selection" })
        keymap.set("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { buffer = bufnr, desc = "Reset selection" })
        keymap.set("n", "<leader>gS", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
        keymap.set("n", "<leader>gR", gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
        keymap.set("n", "<leader>gp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
        keymap.set("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end, { buffer = bufnr, desc = "Blame line" })
      end,
    })
  end,
}
