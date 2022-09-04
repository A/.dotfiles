-- Always open quickfix window at the bottom of the screen
--
local api = vim.api

api.nvim_command('autocmd FileType qf wincmd J')
