local keys = {
  c = {
    name = 'Code Stuff',
    c = { "<cmd>CommentToggle<CR>", 'Comment' },
  },
}


local function install(use)
  use({ 'terrortylor/nvim-comment',
    config = function()
      require('nvim_comment').setup()
    end
  })
end


return {
  install = install,
  keys = keys,
}
