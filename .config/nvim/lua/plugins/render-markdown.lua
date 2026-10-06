return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown', 'vimwiki' },
    opts = {
      callout = {
        quiz = { raw = '[!quiz]', rendered = '󰘥 Quiz', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
        definition = { raw = '[!definition]', rendered = '󰗊 Definition', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
      },
      code = {
        sign = false,
        width = 'block',
        left_pad = 1,
        right_pad = 1,
        border = 'thin',
      },
      pipe_table = {
        preset = 'round',
      },
    },
  },
}
