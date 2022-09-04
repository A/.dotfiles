return function(client)
  -- client.resolved_capabilities.document_formatting = true
  -- client.resolved_capabilities.goto_definition = false

  if client.name == 'tsserver' then
    local ts_utils = require('nvim-lsp-ts-utils')
    if ts_utils then
      ts_utils.setup {}
      ts_utils.setup_client(client)
    end
  end

  if client.name ~= 'efm' then
    client.resolved_capabilities.document_formatting = false
  end

  local lsp_signature = require('lsp_signature')
  if lsp_signature then
    lsp_signature.on_attach()
  end

  if client.resolved_capabilities.document_formatting then
    vim.cmd [[
        augroup Format
          au! * <buffer>
          au BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
        augroup END
      ]]
  end
end
