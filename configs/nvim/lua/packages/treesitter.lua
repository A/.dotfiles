local enabled_treesitter_configs = require('config').enabled_treesitter_configs;

local function use_hook(use)
  use {
    { 'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup({
          ensure_installed = enabled_treesitter_configs
        })
      end
    },
    { 'nvim-treesitter/playground' },
  }
end

return {
  use_hook = use_hook,
}
