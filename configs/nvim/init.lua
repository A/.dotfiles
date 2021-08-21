local cmd = vim.cmd
local fn = vim.fn


require "opts"
require "plugins"
require "lsp"
require "keybindings"

cmd 'colorscheme trash-polka'


-- autocommands
-- cmd 'au CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()'
