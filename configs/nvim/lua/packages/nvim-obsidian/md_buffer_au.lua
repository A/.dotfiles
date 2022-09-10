-- Markdown Buffer Settings
--
local api = vim.api


api.nvim_command('augroup obsidian')
  -- add any nested dirs to the `gf` path, like in obsidian
  api.nvim_command('au BufEnter *.md :setlocal path+=./**')
  
  -- - Filenames may contain spaces
  api.nvim_command('au BufEnter *.md :setlocal isfname+=32')

  -- Automatically add .md ext
  api.nvim_command('au BufEnter *.md :setlocal suffixesadd+=.md')

  -- Force markdown content wrapping
  api.nvim_command('au BufEnter *.md :setlocal wrap linebreak')

  --- Let's `gf` edits file even if it hasn't been created before
  api.nvim_command('au BufEnter *.md :map <buffer> gf :e <cfile>.md<CR>')
api.nvim_command('augroup END')