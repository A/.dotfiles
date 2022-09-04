local enabled_packages = {
  'packages/which-key',
  'packages/nerdtree',
  'packages/theme',
  'packages/indent-blankline',
  'packages/git',
  'packages/lualine',
  'packages/fzf',
  'packages/editorconfig',
  'packages/comment',
  'packages/cmp-completion',
  'packages/lsp',
  'packages/tmux-navigation',
  'packages/nvim-session',
}

local enabled_treesitter_configs = {
  "javascript",
  "tsx",
  "typescript",
  "php",
  "dockerfile",
  "python",
}

return {
  enabled_packages = enabled_packages,
  enabled_treesitter_configs = enabled_treesitter_configs,
}
