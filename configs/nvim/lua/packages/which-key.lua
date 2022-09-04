-- local print_table = require('lib/utils/print_table').print_table
local keys = require('config').keys

local function install(use)
  use 'folke/which-key.nvim'
end

local function post_setup()
  local wk = require("which-key")
  -- print_table(keys)
  wk.register(keys, { prefix = "<leader>", mode = 'n' })
end

return {
  install = install,
  post_setup = post_setup
}
