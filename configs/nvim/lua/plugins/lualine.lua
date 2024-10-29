return {
  "hoob3rt/lualine.nvim",
  event = "VimEnter",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
  },
  config = function()
    local CodeGPTModule = require("codegpt")
    require("lualine").setup({
      options = {
        theme = "nord",
        section_separators = { left = "|", right = "|" },
        component_separators = { left = "|", right = "|" },
      },
      sections = {
        lualine_b = { { "diagnostics", sources = { "nvim_lsp" } }, "lsp_progress" },
        lualine_c = {
          { "filename", path = 1 },
          -- {
          --   function()
          --     return require("lspsaga.symbol.winbar").get_bar()
          --   end,
          -- },
        },
        lualine_x = { CodeGPTModule.get_status, { "diff", colored = false }, "filetype" },
      },
      extensions = { "quickfix", "fugitive", "fzf" },
    })
  end,
}
