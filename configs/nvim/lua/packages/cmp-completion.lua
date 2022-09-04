local function use_hook(use)
  use {
    { "hrsh7th/nvim-cmp",
      config = function()
        local cmp = require "cmp"
        local lspkind = require("lspkind")

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

        require("lib/obsidian_cmp_source")
      end
    },

    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "f3fora/cmp-spell",
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-emoji",
    "onsails/lspkind-nvim",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  }
end

return {
  use_hook = use_hook,
}
