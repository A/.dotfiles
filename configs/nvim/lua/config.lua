local enabled_packages = {
  'packages/packer',
  'packages/which-key',
  'packages/theme',
  'packages/indent-blankline',
  'packages/git',
  'packages/lualine',
  'packages/fzf',
  'packages/editorconfig',
  'packages/comment',
  'packages/cmp-completion',
  -- 'packages/nvim-java',
  'packages/lsp',
  'packages/tmux-navigation',
  'packages/nvim-session',
  'packages/quickfix-to-bottom',
  'packages/nerdtree',
  'packages/treesitter',
  'packages/null-ls',
  'packages/trouble',
  'packages/todo-comments',
  'packages/extended-syntax',
  'packages/glow',
  -- 'packages/obsidian',
  'packages/nvim-colorizer',
  'packages/pretty-fold',
  'packages/nvim-metals',
  -- 'packages/neo-tree',
  'packages/nvim-obsidian',
  -- 'packages/close-buffers',
  -- 'packages/import-cost',
  -- 'packages/todo-txt',
}

local enabled_treesitter_configs = {
  'javascript',
  'tsx',
  'typescript',
  'php',
  'dockerfile',
  'python',
}

local enabled_lsp_servers = {
  'ansiblels',
  'efm',
  'pyright',
  'rust_analyzer',
  'lua_ls',
  'taplo',
  'tsserver',
  'vimls',
  'yamlls',
  'hls',
  -- 'java_language_server',
  -- 'jdtls'
  -- 'jdtls',
}

-- base whichkeys config. Mutated in `<package>.keybindings_hook`
local keys = {}

return {
  enabled_packages = enabled_packages,
  enabled_lsp_servers = enabled_lsp_servers,
  enabled_treesitter_configs = enabled_treesitter_configs,
  keys = keys,
}
