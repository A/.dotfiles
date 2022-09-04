local function use_hook(use)
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use { 'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }
end

local function get_keybindings()
  return {
    g = {
      name = 'git',
      b = { '<cmd>:git blame<cr>', 'blame'},
      d = { '<cmd>:git diff<cr>', 'diff'},
      l = { '<cmd>:git log<cr>', 'log'},
      s = { '<cmd>:git<cr>', 'status'},
      o = { '<cmd>:git browse', 'open url to this file' },
    },
  }
end

return {
  use_hook = use_hook,
  get_keybindings = get_keybindings,
}
