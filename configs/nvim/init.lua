local cmd = vim.cmd
local fn = vim.fn
local api = vim.api

require 'opts'
require 'plugins'
require 'lsp'
require 'keybindings'

-- Local tweaks
require 'lib/vim-tmux-navigation'
require 'lib/nvim-session'

cmd 'colorscheme trash-polka'

api.nvim_command('au BufEnter *.prism :set ft=prisma')

api.nvim_command('augroup obsidian')
  api.nvim_command('au BufEnter *.md :set path+=./**')
  api.nvim_command('au BufEnter *.md :set isfname+=32')
  api.nvim_command('au BufEnter *.md :set suffixesadd+=.md')
  api.nvim_command('au BufEnter *.md :set wrap')
api.nvim_command('augroup END')
