local api = vim.api

-- Save / Load session
local function final_hook()
  api.nvim_command('au BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!')
  api.nvim_command('autocmd BufWinEnter ?* silent! loadview')
end

return {
  final_hook = final_hook,
}


