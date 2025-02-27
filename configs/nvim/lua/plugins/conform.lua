local js_formatting_options = { "prettierd", "prettier", "eslint_d", stop_after_first = false }

return {
  "stevearc/conform.nvim",
  opts = {},

  keys = {
    { "<leader>lF", '<cmd>lua require("conform").format()<CR>', desc = "Format" },
  },

  config = function()
    require("conform").setup({
      format_on_save = function(bufnr)

        local ignore_filetypes = { "helm", "lua" }

        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end

        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        -- Disable autoformat for files in a certain path
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
          return
        end

        return { timeout_ms = 500, lsp_fallback = true }
      end,
      formatters_by_ft = {
        go = { "goimports", "golines", "gofmt", "gofumpt" },
        javascript = js_formatting_options,
        javascriptreact = js_formatting_options,
        typescript = js_formatting_options,
        typescriptreact = js_formatting_options,
        json = { "jq" },

        lua = { "stylua" },
        sh = { "shfmt" },
        terraform = { "terraform_fmt" },
        rust = { "rustfmt" },
        python = { "black" },
      },
    })
  end,
}
