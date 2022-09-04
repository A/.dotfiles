local enabled_lsp_servers = require('config').enabled_lsp_servers
local lsp_status_config = require('packages/lsp/lsp_status_config').lsp_status_config
local keys = require('packages/lsp/keys').keys

local function install(use)
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'ray-x/lsp_signature.nvim'
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'
  use 'nvim-lua/lsp-status.nvim'
  use 'arkav/lualine-lsp-progress'
end

local function setup()
  require('lsp-status').config(lsp_status_config)
end


local function post_setup()
  local lsp_installer_servers = require('nvim-lsp-installer.servers')

  local pyright_settings = require('packages/lsp/lsp_python').settings
  local efm_settings = require('packages/lsp/lsp_efm').settings
  local on_attach = require('packages/lsp/on_attach')

  local server_configs = {
    efm = efm_settings,
    pyright = pyright_settings,
  }

  -- Loop through the servers listed above.
  for _, server_name in pairs(enabled_lsp_servers) do
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
end


return {
  install = install,
  setup = setup,
  post_setup = post_setup,
  keys = keys,
}

