return {
  "echasnovski/mini.map",
  version = false,
  config = function()
    local map = require("mini.map")
    map.setup({
      -- Paint git changes and diagnostics onto the overview column.
      integrations = {
        map.gen_integration.gitsigns(),
        map.gen_integration.diagnostic(),
      },
      symbols = {
        -- Block glyphs shaded by text density read like real code, not dots.
        encode = map.gen_encode_symbols.block("3x2"),
      },
      window = {
        width = 12,
        winblend = 10,
        show_integration_count = false,
      },
    })

    local keymap = vim.keymap
    keymap.set("n", "<leader>mm", map.toggle, { desc = "Minimap toggle" })
    keymap.set("n", "<leader>mf", map.toggle_focus, { desc = "Minimap focus" })

    -- Auto-open for spatial awareness (the reason it exists).
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        map.open()
      end,
    })
  end,
}
