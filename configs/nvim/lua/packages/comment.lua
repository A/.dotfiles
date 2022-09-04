local function use_hook(use)
  use({ 'terrortylor/nvim-comment',
    config = function()
      require('nvim_comment').setup()
    end
  })
end

local function get_keybindings()
  return {
    c = {
      name = 'Code Stuff',
      c = { "<cmd>CommentToggle<CR>", 'Comment' },
    },
  }
end

return {
  use_hook = use_hook,
  get_keybindings = get_keybindings,
}

