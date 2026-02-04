-- Which-key for keybinding hints
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    delay = 300,
    icons = {
      mappings = false,
    },
    spec = {
      { "<leader>n", group = "notes" },
      { "<leader>f", group = "fzf" },
      { "<leader>ff", group = "files" },
      { "<leader>fs", group = "search" },
      { "<leader>fl", group = "lsp" },
      { "<leader>fm", group = "misc" },
      { "<leader>fg", group = "git" },
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
    },
  },
}
