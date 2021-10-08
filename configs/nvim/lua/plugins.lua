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

  use { 
    "nvim-neorg/neorg",
    ft = "norg",
    config = function()
        require('neorg').setup {
            -- Tell Neorg what modules to load
            load = {
                ["core.defaults"] = {}, -- Load all the default modules
                ["core.norg.concealer"] = {}, -- Allows for use of icons
                ["core.norg.dirman"] = { -- Manage your directories with Neorg
                    config = {
                        workspaces = {
                            my_workspace = "~/Dev/@A/norg"
                        }
                    }
                }
            },
            hook = function()
              -- This sets the leader for all Neorg keybinds. It is separate from the regular <Leader>,
              -- And allows you to shove every Neorg keybind under one "umbrella".
              local neorg_leader = "<Leader>" -- You may also want to set this to <Leader>o for "organization"

              -- Require the user callbacks module, which allows us to tap into the core of Neorg
              local neorg_callbacks = require('neorg.callbacks')

              -- Listen for the enable_keybinds event, which signals a "ready" state meaning we can bind keys.
              -- This hook will be called several times, e.g. whenever the Neorg Mode changes or an event that
              -- needs to reevaluate all the bound keys is invoked
              neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)

                -- Map all the below keybinds only when the "norg" mode is active
                keybinds.map_event_to_mode("norg", {
                  n = { -- Bind keys in normal mode

                    -- Keys for managing TODO items and setting their states
                    { "gtd", "core.norg.qol.todo_items.todo.task_done" },
                    { "gtu", "core.norg.qol.todo_items.todo.task_undone" },
                    { "gtp", "core.norg.qol.todo_items.todo.task_pending" },
                    { "<C-Space>", "core.norg.qol.todo_items.todo.task_cycle" }

                  },
                }, { silent = true, noremap = true })

              end)
            end
        }
    end,
    requires = "nvim-lua/plenary.nvim"
  }

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
    config = function()
      require'compe'.setup {
        enabled = true,
        autocomplete = true,
        min_length = 1,
        preselect = 'enable',
        documentation = true,
        source = {
          luasnip = { menu = '[SNP]', priority = 600 },
          nvim_lsp = { priority = 500 },
          path = { priority = 400 },
          buffer = { priority = 400 },
        },
      }
    end,
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

parser_configs.norg = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main"
    },
}

require('nvim-treesitter.configs').setup {
	ensure_installed = { "norg", "javascript", "tsx", "typescript", "php", "dockerfile" },
}
