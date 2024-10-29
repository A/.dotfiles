return {
  "tpope/vim-fugitive",
  dependencies = {
    "tpope/vim-rhubarb",
    "lewis6991/gitsigns.nvim",
  },
  event = "BufEnter",

  keys = {
    { "<leader>g", group = "+Git" },
    { "<leader>gb", "<cmd>:G blame<cr>", desc = "Git blame" },
    { "<leader>gd", "<cmd>:G diff<cr>", desc = "Git diff" },
    { "<leader>gl", "<cmd>:G log<cr>", desc = "Git log" },
    { "<leader>gs", "<cmd>:G<cr>", desc = "Git status" },
    { "<leader>go", "<cmd>:G browse<cr>", desc = "Open url to this file" },
  },

  config = function()
    require("gitsigns").setup()
  end,
}
