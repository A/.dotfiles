local cmd = vim.cmd
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq

require('paq-nvim'):setup({ verbose = true })

paq {'savq/paq-nvim', opt = true}
paq {'A/vim-trash-polka'}
paq {'folke/which-key.nvim'}
paq {'nvim-lua/plenary.nvim'}

paq {'hrsh7th/nvim-compe'}
paq {'neovim/nvim-lspconfig', run = 'npm i -g '..
  'typescript-language-server '..
  'typescript '..
  'vim-language-server '.. 
  'yaml-language-server '..
  'diagnostic-languageserver '
}
paq {'creativenull/diagnosticls-configs-nvim', run = 'npm i -g '..
  'eslint '..
  'eslint_d '..
  'prettier '
}
paq {'ms-jpq/chadtree'}

paq {'ibhagwan/fzf-lua'}
paq {'vijaymarupudi/nvim-fzf'}
paq {'kyazdani42/nvim-web-devicons'}

-- paq {'ojroques/nvim-lspfuzzy'}
paq {'lewis6991/gitsigns.nvim'}
paq {'terrortylor/nvim-comment'}
paq {'nvim-lua/lsp-status.nvim'}
paq {'akinsho/nvim-bufferline.lua'}

require('bufferline').setup{}


require('compe').setup {
  min_length = 2,
  preselect = 'disable',
  max_abbr_width = 80, max_kind_width = 40, max_menu_width = 40,
  source = {buffer = true, path = true, nvim_lsp = true, omni = {filetypes = {'tex'}}},
}

require('gitsigns').setup()
require('nvim_comment').setup()
