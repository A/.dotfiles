-- local lsp_installer = require("nvim-lsp-installer")
--local eslint_config_exists = require('lib.eslint_config_exists')
local lspconfig = require('lspconfig')
local lsp_installer_servers = require('nvim-lsp-installer.servers')
local format_config = require('lsp.format')
local on_attach = require('lsp.on_attach')


local server_names = {
    "efm",
    "tsserver",
    "rust_analyzer",
    "pyright",
    "remark_ls",
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
