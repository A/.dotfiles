require('lib/packer_autoinstall')

local packer = require('packer')

packer.startup(function (use)
  use 'wbthomason/packer.nvim'
  use '~/Dev/@A/vim-trash-polka'
  use 'nvim-lua/plenary.nvim'
  use 'folke/which-key.nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use { 'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }
  use { 'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      require('plugin_settings/lualine_config')
    end
  }
  use {
    'preservim/nerdtree',
    'Xuyuanp/nerdtree-git-plugin',
  }
  use {
    'ibhagwan/fzf-lua',
    'vijaymarupudi/nvim-fzf',
  }
  use 'tpope/vim-fugitive'
  use {
    { 'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = {
            "javascript",
            "tsx",
            "typescript",
            "php",
            "dockerfile",
            "python"
          },
        }
      end
    },
    { 'nvim-treesitter/playground' },
  }
  use 'editorconfig/editorconfig-vim'
  use { 'terrortylor/nvim-comment',
    config = function()
      require('nvim_comment').setup()
    end
  }
  use {
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/nvim-lsp-installer' },
    { 'ray-x/lsp_signature.nvim' },
    { 'jose-elias-alvarez/nvim-lsp-ts-utils' },
    { 'nvim-lua/lsp-status.nvim',
      config = function()
        require('plugin_settings/lsp_status_config')
      end
    },
    { 'arkav/lualine-lsp-progress' },
  }
  -- use {'creativenull/diagnosticls-configs-nvim',
  --   run = table.concat({
  --     'npm i -g',
  --     'eslint',
  --     'eslint_d',
  --     'prettier',
  --   }, ' ')
  -- }

  use {
    { "hrsh7th/nvim-cmp",
      config = function()
        require("plugin_settings/cmp")
        require("lib/obsidian_cmp_source")
      end

    },
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "f3fora/cmp-spell",
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-emoji",
    "onsails/lspkind-nvim",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  }
end)
