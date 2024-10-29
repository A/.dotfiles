return {
  'anuvyklack/pretty-fold.nvim',
  config = function()
    require('pretty-fold').setup({
      fill_char = '·',
    })
  end
}
