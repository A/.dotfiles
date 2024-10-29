return {
  "nvimdev/lspsaga.nvim",

  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "nvim-tree/nvim-web-devicons", -- optional
  },

  cmd = { "Lspsaga" },

  config = function()
    require("lspsaga").setup({
      diagnostic = {
        show_code_action = false,
      },
      symbol_in_winbar = {
        enable = false
      },
      finder = {
        methods = {
          tyd = "textDocument/typeDefinition",
        },
        keys = {
          shuttle = '<C-w>'
        }
      },
      lightbulb = {
        enable = false
      },
    })
  end,

  keys = {
    { "<leader>l", group = "+Lspsaga" },
    { "<leader>lh", "<Cmd>Lspsaga hover_doc<CR>", desc = "Hover a symbol" },
    { "<leader>lH", "<Cmd>Lspsaga hover_doc ++keep<CR>", desc = "Pin Hover" },

    { "<leader>lo", "<Cmd>Lspsaga outline<CR>", desc = "Toggle Outline" },

    { "<leader>lf", group = "+Lspsaga Finder" },
    { "<leader>lff", "<cmd>Lspsaga finder def+ref+imp+tyd<CR>", desc = "Lspsaga Finder" },
    { "<leader>lfr", "<cmd>Lspsaga finder ref<CR>", desc = "List References" },
    { "<leader>lfd", "<cmd>Lspsaga finder def<CR>", desc = "List Definitions" },
    { "<leader>lfi", "<cmd>Lspsaga finder imp<CR>", desc = "List Implementations" },
    { "<leader>lft", "<cmd>Lspsaga finder tyd<CR>", desc = "List Type Definitions" },

    { "<leader>la", "<cmd>Lspsaga code_action<CR>", desc = "List Code Actions" },
    { "<leader>le", "<Cmd>Lspsaga goto_definition<CR>", desc = "Go to Definition" },
    { "<leader>lE", "<Cmd>Lspsaga peek_definition<CR>", desc = "Peek Definition" },
    { "<leader>lt", "<cmd>Lspsaga goto_type_definition<CR>", desc = "Go to Type Definition" },
    { "<leader>lT", "<cmd>Lspsaga peek_type_definition<CR>", desc = "Peek Type Definition" },

    { "<leader>ld", group = "+Diagnostic" },
    { "<leader>ldl", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Show Line Diagnostic" },
    { "<leader>ldw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", desc = "Show Line Diagnostic" },
    { "<leader>ldl", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Show Line Diagnostic" },
    { "<leader>lde", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Go to Previous Diagnostic" },
    { "<leader>ldn", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Go to Next Diagnostic" },
    { "<leader>ldv", "<cmd>lua vim.diagnostic.config({virtual_text = true})<CR>", desc = "Enable Virtual Text" },
    { "<leader>ldV", "<cmd>lua vim.diagnostic.config({virtual_text = false})<CR>", desc = "Disable Virtual Text" },

    { "<leader>lr", "<cmd>Lspsaga rename<CR>", desc = "Rename all symbol references" },
  },
}
