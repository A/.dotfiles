local keys = {
  T = {
    name = 'Trouble',
    i = { '<cmd>TroubleToggle todo<cr>', 'ToDo Comments' },
  },
}


local function install(use)
  use {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
  }
end

local function setup()
  require('todo-comments').setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  })
end

return {
  install = install,
  setup = setup,
  keys = keys,
}
