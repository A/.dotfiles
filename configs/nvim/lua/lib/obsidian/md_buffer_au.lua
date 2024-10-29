-- Markdown Buffer Settings
--
local api = vim.api
local cmd = vim.cmd

api.nvim_command("augroup obsidian")
-- add any nested dirs to the `gf` path, like in obsidian
api.nvim_command("au FileType markdown :setlocal path+=./**")

-- - Filenames may contain spaces
api.nvim_command("au FileType markdown :setlocal isfname+=32")
api.nvim_command("au FileType markdown :setlocal isfname+=&")

-- Automatically add .md ext
api.nvim_command("au FileType markdown :setlocal suffixesadd+=.md")

-- Force markdown content wrapping
api.nvim_command("au FileType markdown :setlocal wrap linebreak")
-- api.nvim_command('au FileType markdown :silent SoftWrapMode')

--- Let's `gf` edits file even if it hasn't been created before
api.nvim_command("au FileType markdown :map <buffer> gf :e <cfile>.md<CR>")
api.nvim_command("au FileType markdown :nmap <buffer> <Right> zo")
api.nvim_command("au FileType markdown :nmap <buffer> <Left> zc")

api.nvim_command(
  "au FileType markdown :syn region markdownWikiLink matchgroup=markdownLinkDelimiter start='\\[\\[' end='\\]\\]' contains=markdownLinkUrl keepend oneline concealends"
)
api.nvim_command([[au! BufEnter,BufNewFile,BufRead *.md syn match markdownTag "#[0-9A-Za-z:._]\+"]])
api.nvim_command("augroup END")
