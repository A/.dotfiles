local table_merge = require('lib/table_merge').table_merge

local function use_hook(use)
  use {
    'preservim/nerdtree',
    'Xuyuanp/nerdtree-git-plugin',
  }
end


local function get_keybindings()
  return {
    n = {
      name = 'NERDTree',
      o = { "<cmd>NERDTree<CR>", 'Open' },
      t = { "<cmd>NERDTreeToggle<CR>", 'Toggle' },
      f = { "<cmd>NERDTreeFind<CR>", 'Find' },
      R = { "<cmd>NERDTreeRefreshRoot<CR>", 'Refresh' },
    },
  }
end

return {
  use_hook = use_hook,
  get_keybindings = get_keybindings,
}
