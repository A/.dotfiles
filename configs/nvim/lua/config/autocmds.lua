vim.api.nvim_command('au BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!')
vim.api.nvim_command('autocmd BufWinEnter ?* silent! loadview')




vim.api.nvim_command("augroup obsidian")
vim.api.nvim_command("au FileType markdown :setlocal path+=./**")
--- Let's `gf` edits file even if it hasn't been created before
vim.api.nvim_command("au FileType markdown :setlocal isfname+=32")
vim.api.nvim_command("au FileType markdown :setlocal isfname+=&")
vim.api.nvim_command("au FileType markdown :setlocal suffixesadd+=.md")
vim.api.nvim_command("au FileType markdown :setlocal wrap linebreak")
vim.api.nvim_command("au FileType markdown :map <buffer> gf :e <cfile>.md<CR>")
vim.api.nvim_command(
  "au FileType markdown :syn region markdownWikiLink matchgroup=markdownLinkDelimiter start='\\[\\[' end='\\]\\]' contains=markdownLinkUrl keepend oneline concealends"
)
vim.api.nvim_command([[au! BufEnter,BufNewFile,BufRead *.md syn match markdownTag "#[0-9A-Za-z:._]\+"]])
-- vim.api.nvim_command('au FileType markdown :silent SoftWrapMode')
vim.api.nvim_command("au FileType markdown :nmap <buffer> <Right> zo")
vim.api.nvim_command("au FileType markdown :nmap <buffer> <Left> zc")
vim.api.nvim_command("augroup END")
