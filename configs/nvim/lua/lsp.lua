local nvim_lsp = require('lspconfig')
local statusline = require('statusline')
local dls = require('diagnosticls-configs')
local lsp_status = require('lsp-status')

lsp_status.register_progress()

function get_lsp_status_text()
  local s = lsp_status.status()
  
  if s == '' then
    s = 'OFF'
  end

  return 'LSP: ' .. s
end

statusline.add(get_lsp_status_text)

local on_attach = function(client, bufnr)
  lsp_status.on_attach(client)
  -- require('completion').on_attach()
end

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



local servers = {'tsserver', 'vimls', 'yamlls'}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
  }
end


-- LUA LSP
require('lspconfig')["sumneko_lua"].setup { on_attach = on_attach, flags = { debounce_text_changes = 150 }}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
  -- cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  cmd = { 'lua-language-server', '-E', './main.lua' };
  settings = {
    Lua = {
      runtime     = { version = 'LuaJIT',path = runtime_path },

      diagnostics = {
        globals   = { "hs", "vim", "it", "describe", "before_each", "after_each" },
        disable   = { "lowercase-global", "undefined-global", "unused-local", "unused-vararg", "trailing-space" }
      },

      workspace   = { library = vim.api.nvim_get_runtime_file("", true), maxPreload = 2000; preloadFileSize = 1000; },
      telemetry   = { enable = false },
    },
      workspace   = { library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
        }
      }
  },
}

