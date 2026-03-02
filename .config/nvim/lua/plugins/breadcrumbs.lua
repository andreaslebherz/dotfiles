return {
  "Bekaboo/dropbar.nvim",
  event = "VeryLazy", -- Only load when you actually start typing/moving
  config = function()
    require("dropbar").setup()
  end,
}
