local util = require('lspconfig/util')
local path = util.path
local env = vim.env
local fn = vim.fn

-- We need to set up the virtual env when using poetry like this, because of the following bug:
-- This was copy pasted -- see GitHub issue https://github.com/neovim/nvim-lspconfig/issues/500
-- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-876700701
-- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-877293306
local function get_python_path(workspace)
  -- Use activated virtualenv.
  if env.VIRTUAL_ENV then
    return path.join(env.VIRTUAL_ENV, 'bin', 'python')
  end

  -- Find and use virtualenv via poetry in workspace directory.
  local match = fn.glob(path.join(workspace, 'poetry.lock'))
  if match ~= '' then
    local venv = fn.trim(fn.system('poetry env info -p'))
    return path.join(venv, 'bin', 'python')
  end

  -- Fallback to system Python.
  return fn.exepath('python3') or fn.exepath('python') or 'python'
end


local function on_init(client)
    client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
end


local settings = {
  analysis = {
    autoSearchPaths = true,
    diagnosticMode = "workspace",
    useLibraryCodeForTypes = true,
    typeCheckingMode = "off", -- this needs to be turned off if Django type stubs are not installed
  },
  on_init = on_init,
}


return {
  settings = settings,
}
