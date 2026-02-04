return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>n", group = "+Tree" },
    { "<leader>no", "<cmd>Neotree focus<cr>", desc = "Open" },
    { "<leader>nt", "<cmd>Neotree toggle<cr>", desc = "Toggle" },
    { "<leader>nf", "<cmd>Neotree reveal<cr>", desc = "Find" },
    { "<leader>nR", "<cmd>Neotree refresh<cr>", desc = "Refresh" },
  },
  opts = {
    close_if_last_window = true,
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    window = {
      width = 30,
      mappings = {
        ["<space>"] = "none",
      },
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added = "+",
          modified = "~",
          deleted = "✖",
          renamed = "➜",
          untracked = "?",
          ignored = "◌",
          unstaged = "✗",
          staged = "✓",
          conflict = "",
        },
      },
    },
  },
}
