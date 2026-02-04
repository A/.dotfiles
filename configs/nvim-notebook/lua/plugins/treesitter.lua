-- Treesitter - Syntax highlighting for markdown and code blocks
-- Uses new nvim-treesitter API (main branch, requires Neovim 0.11+)
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- This plugin does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    -- Install parsers
    local parsers = {
      "markdown",
      "markdown_inline",
      "lua",
      "vim",
      "vimdoc",
      "bash",
      "python",
      "javascript",
      "typescript",
      "json",
      "yaml",
      "html",
      "css",
    }

    require("nvim-treesitter").install(parsers)

    -- Enable treesitter highlighting
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "markdown",
        "lua",
        "vim",
        "bash",
        "sh",
        "python",
        "javascript",
        "typescript",
        "json",
        "yaml",
        "html",
        "css",
      },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
