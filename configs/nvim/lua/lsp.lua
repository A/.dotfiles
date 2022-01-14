local lspconfig = require('lspconfig')

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

local function eslint_config_exists()
  local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)

  if not vim.tbl_isempty(eslintrc) then
    return true
  end

  if vim.fn.filereadable("package.json") then
    if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
      return true
    end
  end

  return false
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = false,
        signs = true,
    }
)

lspconfig.tsserver.setup({ on_attach = function(client)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
end})

lspconfig.efm.setup {
  init_options = {
    documentFormatting = true
  },
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.goto_definition = false
  end,
  root_dir = function()
    if not eslint_config_exists() then
      return nil
    end
    return vim.fn.getcwd()
  end,
  settings = {
    languages = {
      javascript = {eslint},
      javascriptreact = {eslint},
      ["javascript.jsx"] = {eslint},
      typescript = {eslint},
      ["typescript.tsx"] = {eslint},
      typescriptreact = {eslint}
    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact"
  },
}

lspconfig.vimls.setup({})
lspconfig.yamlls.setup({})
lspconfig.dockerls.setup({})
lspconfig.prismals.setup({})
lspconfig.intelephense.setup({})
lspconfig.pyright.setup({})


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

