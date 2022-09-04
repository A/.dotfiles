local table_merge = require('lib/table_merge').table_merge
local keys = require('keys_config').keys
local enabled_packages = require('config').enabled_packages

require('lib/packer_autoinstall')

local packer = require('packer')

packer.startup(function (use)
  use 'wbthomason/packer.nvim'
  -- TODO: put into require where it needed
  use 'nvim-lua/plenary.nvim'

  -- Call use hooks if exist
  for _,p in pairs(enabled_packages) do
    local package = require(p)

    if package.use_hook~=nil then
      package.use_hook(use)
    end
  end

  -- Call keybindings hooks if exist
  for _,p in pairs(enabled_packages) do
    local package = require(p)
    if package.get_keybindings~=nil then
      print()
      local package_keys = package.get_keybindings()
      table_merge(keys, package_keys)
    end
  end

  -- Call final hooks if exist
  for _,p in pairs(enabled_packages) do
    local package = require(p)
    if package.final_hook~=nil then
      package.final_hook()
    end
  end

end)
