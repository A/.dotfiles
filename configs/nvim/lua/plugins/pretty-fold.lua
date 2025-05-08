return {
  'anuvyklack/pretty-fold.nvim',
  enabled = false,

  config = function()
    require('pretty-fold').setup({
      fill_char = '·',
    })
  end
}
