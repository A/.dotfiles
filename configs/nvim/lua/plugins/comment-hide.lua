return {
  "jiangxue-analysis/nvim.comment-hide",
  name = "comment-hide",
  lazy = false,
  config = function()
    require("comment-hide").setup({
      gitignore = true, -- Automatically add .annotations/ to .gitignore.
    })
    vim.keymap.set("n", "<leader>gh", "<cmd>CommentHideSave<CR>", { desc = "Comment: Save (strip comments)" })
    vim.keymap.set("n", "<leader>gr", "<cmd>CommentHideRestore<CR>", { desc = "Comment: Restore from backup" })
  end,
}
