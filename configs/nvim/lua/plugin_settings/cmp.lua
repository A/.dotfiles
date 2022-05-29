-- Setup nvim-cmp.
local cmp = require "cmp"
local lspkind = require("lspkind")

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
               and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(
                   col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true),
                          mode, true)
end

lspkind.init({
    symbol_map = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "ﰠ",
        Variable = "",
        Class = "ﴯ",
        Interface = "",
        Module = "",
        Property = "ﰠ",
        Unit = "塞",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "פּ",
        Event = "",
        Operator = "",
        TypeParameter = ""
    }
})

cmp.setup({
  snippet = {
  expand = function(args)
    require('luasnip').lsp_expand(args.body)
  end,
  },
  formatting = {
      format = lspkind.cmp_format {
          with_text = false,
          maxwidth = 50,
          menu = {
              buffer = "BUF",
              nvim_lsp = "LSP",
              path = "PATH",
              calc = "CALC",
              spell = "SPELL",
              emoji = "EMOJI"
          }
      }
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  experimental = {native_menu = false, ghost_text = false},
  sources = {
      {name = "nvim_lsp"}, { name = 'luasnip' }, {name = "buffer", keyword_length = 5},
      {name = "calc"}, {name = "emoji"}, {name = "spell"},
      {name = "path"}, {name = "obsidian"}
  }
})

-- Use buffer source for `/`.
cmp.setup.cmdline("/", {sources = {{name = "buffer"}}})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({{name = "path"}}, {{name = "cmdline"}})
})
