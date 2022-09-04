-- local print_table = require('lib/utils/print_table').print_table
local keys = require('keys_config').keys

local function use_hook(use)
  use 'folke/which-key.nvim'
end

local function final_hook()
  local wk = require("which-key")
  -- print_table(keys)
  wk.register(keys, { prefix = "<leader>", mode = 'n' })
end

return {
  use_hook = use_hook,
  final_hook = final_hook
}
