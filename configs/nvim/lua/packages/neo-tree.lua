return function(use)
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
