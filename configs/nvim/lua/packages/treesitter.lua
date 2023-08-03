local enabled_treesitter_configs = require('config').enabled_treesitter_configs;

local function install(use)
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

        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.markdown = {
          install_info = {
            url = "https://github.com/MDeiml/tree-sitter-markdown.git",
            files = { "src/parser.c" },
            branch = "main",
            generate_requires_npm = false,
            requires_generate_from_grammar = false,
          },
          filetype = "md",
        }
      end
    },
    { 'nvim-treesitter/playground' },
  }
end

return {
  install = install,
}
