local fn = vim.fn
local execute = vim.api.nvim_command

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end


local packer = require('packer')


packer.startup(function (use)
  use 'wbthomason/packer.nvim'
  -- use 'sheerun/vim-polyglot'

  -- help
  use { 'folke/which-key.nvim',
    requires = {{ 'nvim-lua/plenary.nvim' }} 
  }

  -- ui
  use '~/Dev/@A/vim-trash-polka'
  use 'kyazdani42/nvim-web-devicons'
  use 'lukas-reineke/indent-blankline.nvim'
  use { 'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  use { 'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }

  -- file tree
  -- use {
  --   'kyazdani42/nvim-tree.lua',
  --   requires = 'kyazdani42/nvim-web-devicons',
  --   config = function() 
  --     vim.g['nvim_tree_disable_window_picker'] = 1
  --   end,
  -- }

  use 'preservim/nerdtree'
  use 'Xuyuanp/nerdtree-git-plugin'

  -- use 'justinmk/vim-dirvish'
  -- use 'kristijanhusak/vim-dirvish-git'

  -- tools
  use 'ibhagwan/fzf-lua'
  use 'vijaymarupudi/nvim-fzf'
  use { 'tpope/vim-fugitive' }

  -- treesitter
  use { 'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'nvim-treesitter/playground'

  -- dev
  use 'pantharshit00/vim-prisma'
  use 'editorconfig/editorconfig-vim'
  use { 'terrortylor/nvim-comment',
    config = function()
      require('nvim_comment').setup()
    end
  }

  -- lsp
  use { 'neovim/nvim-lspconfig',
    run = table.concat({
      'npm i -g',
      'typescript-language-server',
      'typescript',
      'vim-language-server',
      'yaml-language-server',
      'diagnostic-languageserver',
      'dockerfile-language-server-nodejs',
      'ansible-language-server',
      '@prisma/language-server',
    }, ' ')
  }
  use 'nvim-lua/lsp-status.nvim'
  use 'arkav/lualine-lsp-progress'

  use {'creativenull/diagnosticls-configs-nvim',
    run = table.concat({
      'npm i -g',
      'eslint',
      'eslint_d',
      'prettier',
    }, ' ')
  }

  -- completion
  use {
    "hrsh7th/nvim-compe",
    wants = {"LuaSnip"},
    requires = {
        {
            "L3MON4D3/LuaSnip",
            wants = "friendly-snippets",
            config = function()
                require("luasnip/loaders/from_vscode").load()
            end
        },
        "rafamadriz/friendly-snippets"
    }
  }
end)

require('lsp-status').config({
  indicator_errors = 'E:',
  indicator_warnings = 'W:',
  indicator_info = 'I:',
  indicator_hint = 'H:',
  indicator_ok = 'Ok',
  current_function = false,
  show_filename = false,

})


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





local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

require('nvim-treesitter.configs').setup {
	ensure_installed = { "javascript", "tsx", "typescript", "php", "dockerfile" },
}

-- local id = require'compe'.register_source('obs', require'lib/compe_obsidian')

-- print(id)

require'compe'.setup {
  enabled = true,
  autocomplete = true,
  min_length = 1,
  debug = true,
  preselect = 'enable',
  documentation = true,
  source = {
    obs = { priority = 10000, menu = '[OBS]' },
    luasnip = { menu = '[SNP]', priority = 600 },
    nvim_lsp = { priority = 500 },
    path = { priority = 400 },
    buffer = { priority = 400 }
  },
}

