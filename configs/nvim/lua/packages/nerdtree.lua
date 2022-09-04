local function install(use)
  use {
    'preservim/nerdtree',
    'Xuyuanp/nerdtree-git-plugin',
  }
end


local keys = {
  n = {
    name = 'NERDTree',
    o = { "<cmd>NERDTree<CR>", 'Open' },
    t = { "<cmd>NERDTreeToggle<CR>", 'Toggle' },
    f = { "<cmd>NERDTreeFind<CR>", 'Find' },
    R = { "<cmd>NERDTreeRefreshRoot<CR>", 'Refresh' },
  },
}

return {
  install = install,
  keys = keys,
}
