local function use_hook(use)
  use {
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/nvim-lsp-installer' },
    { 'ray-x/lsp_signature.nvim' },
    { 'jose-elias-alvarez/nvim-lsp-ts-utils' },
    { 'nvim-lua/lsp-status.nvim',
      config = function()
        require('lsp-status').config({
          indicator_errors = 'E:',
          indicator_warnings = 'W:',
          indicator_info = 'I:',
          indicator_hint = 'H:',
          indicator_ok = 'Ok',
          current_function = false,
          show_filename = false,
        })
      end
    },
    { 'arkav/lualine-lsp-progress' },
  }
end

local function final_hook()
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
end

local function get_keybindings()
  return {
    l = {
      name = 'LSP',
      a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Select a code action' },
      d = {
        name = 'Diagnostic actions..',
        d = { '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', 'Open diagnostics window for current line' },
        e = {'<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', 'Go to previous diagnostic'},
        n = {'<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', 'Go to next diagnostic'},
      },
      E = {'<Cmd>lua vim.lsp.buf.declaration()<CR>', 'Jump to symbol declaration'},
      e = {'<Cmd>lua vim.lsp.buf.definition()<CR>', 'Jump to symbol definition'},
      f = {"<cmd>lua vim.lsp.buf.formatting()<CR>", 'Format the current buffer'},
      h = {'<Cmd>lua vim.lsp.buf.hover()<CR>', 'Display hover information for symbol'},
      H = {'<Cmd>lua vim.lsp.buf.hover();vim.lsp.buf.hover()<CR>', 'Jump into hover information for symbol'},
      i = {'<cmd>lua vim.lsp.buf.implementation()<CR>', 'List implementations for symbol'},
      l = {'<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', 'Set location list'},
      r = {'<cmd>lua vim.lsp.buf.references()<CR>', 'List references for symbol'},
      R = {'<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename all symbol references'},
      s = {'<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Display signature information for symbol'},
      t = {'<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Jump to symbol type definition'},
      w = {
        name = 'Workspace actions...',
        a = {'<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add folder to workspace'},
        r = {'<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove folder from workspace'},
        l = {'<cmd>lua print()vim.inspect()vim.lsp.buf.list_workspace_folders()<CR>', 'List folders in workspace'},
      },
    },
  }
end

return {
  use_hook = use_hook,
  final_hook = final_hook,
  get_keybindings = get_keybindings,
}

