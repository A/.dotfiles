-- Tmux navigation
return {
  "alexghergh/nvim-tmux-navigation",
  config = function()
    require("nvim-tmux-navigation").setup({
      disable_when_zoomed = true,
    })

    vim.keymap.set("n", "<S-Down>", ":NvimTmuxNavigateDown<CR>", { noremap = true })
    vim.keymap.set("n", "<S-Up>", ":NvimTmuxNavigateUp<CR>", { noremap = true })
    vim.keymap.set("n", "<S-Right>", ":NvimTmuxNavigateRight<CR>", { noremap = true })
    vim.keymap.set("n", "<S-Left>", ":NvimTmuxNavigateLeft<CR>", { noremap = true })
  end,
}
