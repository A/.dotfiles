-- markdown-oxide v0.25.10 panics (exit 101) in src/vault/mod.rs:597 when a
-- didOpen URI has no file stem, which is what nvim sends for unnamed or
-- scratch `filetype=markdown` buffers. Only attach to real files on disk.
---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" or vim.bo[bufnr].buftype ~= "" or name:find("://") then
      return
    end
    on_dir(vim.fs.root(bufnr, { ".git", ".obsidian", ".moxide.toml" }) or vim.fs.dirname(name))
  end,
}
