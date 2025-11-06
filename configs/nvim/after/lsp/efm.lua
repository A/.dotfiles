local eslint = {
  lintCommand = "eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = { "%f(%l,%c): %tarning %m", "%f(%l,%c): %rror %m" },
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true,
}

local flake8 = {
  lintCommand = "flake8 ${INPUT}",
  lintStdin = true,
}

local black = {
  formatCommand = "black --quiet -",
  formatStdin = true,
}

local luacheck = {
  lintCommand = "luacheck --codes --no-color --quiet -",
  lintStdin = true,
  lintFormats = { "%.%#:%l:%c: (%t%n) %m" },
}

local stylua = {
  formatCommand = "stylua --search-parent-directories -",
  formatStdin = true,
}

return {
  cmd = { "efm-langserver" },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      javascript = { eslint },
      javascriptreact = { eslint },
      typescript = { eslint },
      typescriptreact = { eslint },
      python = { flake8, black },
    },
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "go",
    "python",
    "lua",
    "php",
  },
  init_options = { documentFormatting = true, codeAction = true },
}
