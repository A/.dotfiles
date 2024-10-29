return {
  'preservim/nerdtree',
  dependencies = {
    'Xuyuanp/nerdtree-git-plugin',
  },
  keys = {
    { "<leader>n", group = "+Tree" },
    { "<leader>no", ":NERDTree<CR>", "Open" },
    { "<leader>nt", ":NERDTreeToggle<CR>", "Toggle" },
    { "<leader>nf", ":NERDTreeFind<CR>", "Find" },
    { "<leader>nR", ":NERDTreeRefreshRoot<CR>", "Refresh" },
  },
}
