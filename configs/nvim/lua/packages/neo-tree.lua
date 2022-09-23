local keys = {
  n = {
    name = 'Neotree',
    o = { "<cmd>Neotree<CR>", 'Open' },
    t = { "<cmd>Neotree toggle<CR>", 'Toggle' },
    b = { "<cmd>Neotree action=show source=buffers position=right toggle=true<CR>", 'Toggle Buffers' },
    f = { "<cmd>Neotree reveal<CR>", 'Show current file' },
    g = { "<cmd>Neotree float git_status<CR>", 'Git Status' },
  }
}


local function install(use)
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
  use {
    "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      }
    }
end

local function setup()
  require("neo-tree").setup({
    window = {
      position = "left",
      width = 40,
      mappings = {
        ["F"] = "fuzzy_finder",
        ["/"] = "none",
        ["D"] = "none",
      }
    },
    default_component_configs = {
      indent = {
        highlight = "Comment",
      },
    },
  })

  vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
end

return {
  install = install,
  setup = setup,
  keys = keys,
}
