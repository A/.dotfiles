local api = vim.api

-- Save / Load session
local function post_setup()
  api.nvim_command('au BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!')
  api.nvim_command('autocmd BufWinEnter ?* silent! loadview')
end

return {
  post_setup = post_setup,
}


