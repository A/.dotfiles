-- local root_dir_basedpyright = function(bufnr, cb)
--   local root = vim.fs.root(bufnr, {
--     "pyproject.toml",
--     "pyrightconfig.json",
--     ".git",
--   }) or vim.fn.expand("%:p:h")
--   cb(root)
-- end

return {
  -- root_dir = root_dir_basedpyright,
  settings = {
    basedpyright = {
      typeCheckingMode = "standard",
      useLibraryCodeForTypes = true,
      analysis = {
        diagnosticMode = "openFilesOnly",
        inlayHints = {
          callArgumentNames = true
        }
      }
    }
  }
}
