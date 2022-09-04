local cmd = vim.cmd


local keys = {
  u = {
    name = 'UI & Theme',
    d = { '<cmd>:lua vim.cmd(":colorscheme trash-polka")<CR>', 'Toggle dark theme'},
    l = { '<cmd>:lua vim.cmd(":colorscheme trash-polka-light")<CR>', 'Toggle light theme'},
  }
}


local function install(use)
  use({
    '~/Dev/@A/vim-trash-polka',
    config = function()
    end
  })
end


local function setup()
  cmd 'colorscheme trash-polka'
end


return {
  install = install,
  setup = setup,
  keys = keys,
}
