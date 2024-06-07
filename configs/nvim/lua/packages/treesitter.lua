local enabled_treesitter_configs = require('config').enabled_treesitter_configs;

local function install(use)
  -- use "MDeiml/tree-sitter-markdown"
  use {
    { 'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup({
          ensure_installed = enabled_treesitter_configs,
          auto_install = true,
          highlight = {
            enable = true,
          }
        })
      end
    },
    { 'nvim-treesitter/playground' },
  }
end

return {
  install = install,
}
