local function use_hook(use)
  use({
    '~/Dev/@A/vim-trash-polka',
    config = function()
      vim.cmd 'colorscheme trash-polka'
    end
  })
end

local function get_keybindings()
  return {
    u = {
      name = 'UI & Theme',
      d = { '<cmd>:lua vim.cmd(":colorscheme trash-polka")<CR>', 'Toggle dark theme'},
      l = { '<cmd>:lua vim.cmd(":colorscheme trash-polka-light")<CR>', 'Toggle light theme'},
    }
  }
end

return {
  use_hook = use_hook,
  get_keybindings = get_keybindings,
}
