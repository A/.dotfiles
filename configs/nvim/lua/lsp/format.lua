local eslint = {
  lintCommand = 'eslint_d -f unix --stdin --stdin-filename ${INPUT}',
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { '%f:%l:%c: %m' },
  formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
  formatStdin = true,
}

local prettier = { formatCommand = './node_modules/.bin/prettier --stdin-filepath ${INPUT}', formatStdin = true }
local stylua = { formatCommand = 'stylua -s -', formatStdin = true }
local blue = { formatCommand = 'blue --quiet -', formatStdin = true }
local pylint = {
    lintCommand = 'pylint --output-format text --score no --msg-template {path}:{line}:{column}:{C}:pylint:{msg} --load-plugins=pylint_django --load-plugins=pylint_django.checkers.migrations ${INPUT}',
    lintFormats = {"%f:%l:%c:%t:%m"},
    lintStdin = false,
    lintOffsetColumns = 1,
    lintCategoryMap = {I = 'H', R = 'I', C = 'I', W = 'W', E = 'E', F = 'E'}
  }

return {
  css = { prettier },
  html = { prettier },
  javascript = { prettier, eslint },
  javascriptreact = { prettier, eslint },
  json = { prettier },
  lua = { stylua },
  markdown = { prettier },
  python = { blue },
  scss = { prettier },
  typescript = { prettier, eslint },
  typescriptreact = { prettier, eslint },
  yaml = { prettier },
}
