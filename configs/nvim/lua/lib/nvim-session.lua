local api = vim.api
--
-- Save / Load session
api.nvim_command('au BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!')
api.nvim_command('autocmd BufWinEnter ?* silent! loadview')
