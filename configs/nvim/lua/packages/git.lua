local keys = {
  g = {
    name = 'git',
    b = { '<cmd>:G blame<cr>', 'blame'},
    d = { '<cmd>:G diff<cr>', 'diff'},
    l = { '<cmd>:G log<cr>', 'log'},
    s = { '<cmd>:G<cr>', 'status'},
    o = { '<cmd>:G browse', 'open url to this file' },
  },
}


local function install(use)
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use { 'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }
end

return {
  install = install,
  keys = keys,
}
