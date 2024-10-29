return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },

  config = function()
    local highlight = {
      "Red",
      "Blue",
      "Red",
      "Blue",
      "Red",
      "Blue",
      "Red",
    }

    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "Red", { fg = "#9e8284" })
      vim.api.nvim_set_hl(0, "Blue", { fg = "#94a1ae" })
      vim.api.nvim_set_hl(0, "Red", { fg = "#9e8284" })
      vim.api.nvim_set_hl(0, "Blue", { fg = "#94a1ae" })
      vim.api.nvim_set_hl(0, "Red", { fg = "#9e8284" })
      vim.api.nvim_set_hl(0, "Blue", { fg = "#94a1ae" })
      vim.api.nvim_set_hl(0, "Red", { fg = "#9e8284" })
    end)

    require("ibl").setup({
      indent = {
        highlight = highlight,
        char = "┃",
        tab_char = "┃",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    })
  end,
}
