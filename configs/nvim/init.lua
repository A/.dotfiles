local cmd = vim.cmd
local fn = vim.fn

require 'opts'
require 'plugins'
require 'lsp'
require 'keybindings'

-- Local tweaks
require 'lib/vim-tmux-navigation'
require 'lib/nvim-session'

cmd 'colorscheme trash-polka'

vim.api.nvim_command('au BufEnter *.prism :set ft=prisma')

