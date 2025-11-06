return {
    cmd = { "cssmodules-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { ".git" },
    on_attach = function (client)
      client.server_capabilities.definitionProvider = false
    end,
}
