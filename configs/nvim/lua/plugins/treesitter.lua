return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-treesitter/playground" },

  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ignore_install = {},
      auto_install = false,
      modules = {},
      ensure_installed = {
        "html",
        "javascript",
        "markdown",
        "markdown_inline",
        "python",
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
