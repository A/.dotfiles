-- local lsp_installer = require("nvim-lsp-installer")
--local eslint_config_exists = require('lib.eslint_config_exists')
local lspconfig = require('lspconfig')
local lsp_installer_servers = require('nvim-lsp-installer.servers')
local format_config = require('lsp.format')
local on_attach = require('lsp.on_attach')
local util = require('lspconfig/util')
local path = util.path

-- We need to set up the virtual env when using poetry like this, because of the following bug:
-- This was copy pasted -- see GitHub issue https://github.com/neovim/nvim-lspconfig/issues/500
-- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-876700701
-- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-877293306
local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  -- Find and use virtualenv via poetry in workspace directory.
  local match = vim.fn.glob(path.join(workspace, 'poetry.lock'))
  if match ~= '' then
    local venv = vim.fn.trim(vim.fn.system('poetry env info -p'))
    return path.join(venv, 'bin', 'python')
  end

  -- Fallback to system Python.
  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

local on_init = function(client)
  client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
end

local server_names = {
    "efm",
    "tsserver",
    "rust_analyzer",
    "pyright",
    "ansiblels",
    "yamlls",
    "taplo",
    "sumneko_lua",
    "vimls",
}

local server_configs = {
  efm = {
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
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
          typeCheckingMode = "off", -- this needs to be turned off if Django type stubs are not installed
          extraPaths = {
            "~/KOG/kog/data_apps",
            "~/KOG/kog/api_apps",
            "~/KOG/kog/gui_apps",
            "~/KOG/kog",
          }
        }
      }
    },
    on_init = on_init,
  }
}

-- Loop through the servers listed above.
for _, server_name in pairs(server_names) do
    local server_available, server = lsp_installer_servers.get_server(server_name)
    if server_available then
        server:on_ready(function ()
          local config = server_configs[server_name] or {}
          config.on_attach = on_attach
          server:setup(config)
          vim.cmd [[ do User LspAttachBuffers ]]
        end)
        if not server:is_installed() then
            -- Queue the server to be installed.
            server:install()
        end
    end
end
