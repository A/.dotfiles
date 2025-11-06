-- local SymbolKind = vim.lsp.protocol.SymbolKind
--
-- return {
--   "Wansmer/symbol-usage.nvim",
--   event = { "LspAttach" },
--   enabled = false,
--   config = function()
--     require("symbol-usage").setup({
--       kinds = {
--         SymbolKind.Function,
--         SymbolKind.Method,
--         SymbolKind.Class,
--         SymbolKind.Constant,
--         SymbolKind.Interface,
--         SymbolKind.Variable,
--       },
--       vt_position = "end_of_line",
--     })
--   end,
-- }


return {
  'VidocqH/lsp-lens.nvim',
  enabled = false,
  config = function ()
    require'lsp-lens'.setup({})
  end
}
