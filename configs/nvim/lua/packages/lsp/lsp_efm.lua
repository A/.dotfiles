local lspconfig = require('lspconfig')
local format_config = require('packages/lsp/format')

local settings = {
  filetypes = vim.tbl_keys(format_config),
  init_options = {
    documentFormatting = true,
    hover = true,
    documentSymbol = true,
    codeAction = true,
    completion = true,
  },
  root_dir = lspconfig.util.root_pattern { '.git/', '.' },
  settings = { languages = format_config },
}

return {
  settings = settings,
}
