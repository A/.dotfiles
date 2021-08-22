local cmd = vim.cmd
local fn = vim.fn

require 'opts'
require 'plugins'
require 'lsp'
require 'keybindings'
require 'statusline'.setup()

cmd 'colorscheme trash-polka'
