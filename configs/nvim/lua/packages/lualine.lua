local function install(use)
  use { 'hoob3rt/lualine.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons', opt = true,
      config = function()
        require('lualine').setup({
          options = {
            theme = '16color',
            section_separators = { left = '|', right = '|'},
            component_separators = { left = '|', right = '|'},
          },
          sections = {
            lualine_b = {{'diagnostics', sources={'nvim_lsp'}}, 'lsp_progress'},
            lualine_c = {{'filename', path = 1}},
            lualine_x = {{'diff', colored = false}, 'filetype'}
          },
          extensions = {'quickfix', 'fugitive', 'fzf'}
        })
      end
    },
  }
end

return {
  install = install,
}

