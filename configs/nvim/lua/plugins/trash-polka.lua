return {
  dir = "~/Dev/@A/vim-trash-polka/",
  name = "trash-polka",
  lazy = false,
  dev = true,
  priority = 1000,

  keys = {
    { "<leader>u", desc = "UI" },
    { "<leader>ul", ":colorscheme trash-polka-light<CR>", "Toggle light theme" },
    { "<leader>ud", ":colorscheme trash-polka<CR>", "Toggle dark theme" },
  },

  config = function()
    require("colorscheme")
  end,
}
