local has_prop    = require('lib/utils/has_prop').has_prop
local table_merge = require('lib/utils/table_merge').table_merge
-- local dump        = require('lib.utils.dump').dump


local init = function(config)
  local keys = config.keys
  local enabled_packages = config.enabled_packages

  -- Call pre_install hooks
  has_prop(enabled_packages, 'pre_install', function(package)
    package.pre_install()
  end)

  require('packer').startup(function (use)
    -- Call install hooks
    has_prop(enabled_packages, 'install', function(package)
      package.install(use)
    end)

    -- Call setup hooks
    has_prop(enabled_packages, 'setup', function(package)
      package.setup()
    end)

    -- Get keybindings
    has_prop(enabled_packages, 'keys', function(package)
      table_merge(keys, package.keys)
    end)
  end)

  -- Call post_setup hooks
  has_prop(enabled_packages, 'post_setup', function(package)
    package.post_setup()
  end)
end


return {
  init = init,
}
