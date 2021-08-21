local cmd = vim.cmd
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq

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
