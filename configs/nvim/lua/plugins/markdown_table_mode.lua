return {
  'Kicamon/markdown-table-mode.nvim',
  config = function()
    require('markdown-table-mode').setup()
  end,
  keys = {
    { "<leader>mt", '<cmd>Mtm<CR>', desc = "Format table" },
  },
}
