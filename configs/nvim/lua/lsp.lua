local nvim_lsp = require('lspconfig')
local dls = require('diagnosticls-configs')

dls.init({ on_attach = on_attach })
dls.setup({
  javascript = {
    linter = require 'diagnosticls-configs.linters.eslint_d',
    formatter = require 'diagnosticls-configs.formatters.prettier',
  },
  javascriptreact = {
    linter = require 'diagnosticls-configs.linters.eslint_d',
    formatter = require 'diagnosticls-configs.formatters.prettier',
  },
  typescript = {
    linter = require 'diagnosticls-configs.linters.eslint_d',
    formatter = require 'diagnosticls-configs.formatters.prettier',
  },
  typescriptreact = {
    linter = require 'diagnosticls-configs.linters.eslint_d',
    formatter = require 'diagnosticls-configs.formatters.prettier',
  },
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = false,
        signs = true,
    }
)


local on_attach = function(_, bufnr)
  -- require('completion').on_attach()
end

local servers = {'tsserver', 'vimls', 'yamlls'}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
  }
end
