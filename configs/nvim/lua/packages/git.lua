local keys = {
  g = {
    name = 'git',
    b = { '<cmd>:git blame<cr>', 'blame'},
    d = { '<cmd>:git diff<cr>', 'diff'},
    l = { '<cmd>:git log<cr>', 'log'},
    s = { '<cmd>:git<cr>', 'status'},
    o = { '<cmd>:git browse', 'open url to this file' },
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
