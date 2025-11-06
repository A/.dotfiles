return {
  "saghen/blink.cmp",
  version = "*",
  event = "InsertEnter",
  -- dependencies = {
  --   "rafamadriz/friendly-snippets",
  -- },
  opts = {
    keymap = {
      preset = "default",
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-CR>"] = { "cancel", "fallback" },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },

    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
          components = {
            label = {
              width = { fill = true, max = 40 },
              text = function(ctx)
                return ctx.label .. (ctx.label_detail or "")
              end,
            },
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                return ctx.kind_icon .. ctx.icon_gap
              end,
            },
            kind = {
              width = { max = 30 },
              ellipsis = true,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
        },
      },
      ghost_text = {
        enabled = true,
      },
    },

    sources = {
      default = { "lsp", "path", "buffer" },
    },

    signature = {
      enabled = true,
      window = {
        border = "rounded",
      },
    },
  },
}
