local function install(use)
  use 'anuvyklack/pretty-fold.nvim'
end

local function setup()
  require('pretty-fold').setup({
    fill_char = '·',
  })
end


return {
  install = install,
  setup = setup,
}
