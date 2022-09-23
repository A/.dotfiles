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
  require('nvim-lsp-installer').setup({})
end


local function post_setup()
  local lsp_installer_servers = require('nvim-lsp-installer.servers')

  local pyright_settings = require('packages/lsp/lsp_python').settings
  local efm_settings = require('packages/lsp/lsp_efm').settings

  local server_configs = {
    efm = efm_settings,
    pyright = pyright_settings,
  }

  -- Loop through the servers listed above.
  for _, server_name in pairs(enabled_lsp_servers) do
      local lspconfig = require('lspconfig')
      local config = server_configs[server_name] or {}

      config.on_attach = function(client)
        if client.name ~= 'null_ls' then
          client.resolved_capabilities.document_formatting = false
        end
      end

      lspconfig[server_name].setup(config)
      vim.cmd [[ do User LspAttachBuffers ]]
  end
end


return {
  install = install,
  setup = setup,
  post_setup = post_setup,
  keys = keys,
}

