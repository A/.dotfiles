-- Always open quickfix window at the bottom of the screen
local api = vim.api

local function install()
  api.nvim_command('autocmd FileType qf wincmd J')
end

return {
  install = install,
}
