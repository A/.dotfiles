local lsp_status_config = {
  indicator_errors = 'E:',
  indicator_warnings = 'W:',
  indicator_info = 'I:',
  indicator_hint = 'H:',
  indicator_ok = 'Ok',
  current_function = false,
  show_filename = false,
}

return {
  lsp_status_config = lsp_status_config,
}
