local function install(use)
  use 'NvChad/nvim-colorizer.lua'
end

local function setup()
  require'colorizer'.setup()
end

return {
  install = install,
  setup = setup,
}
