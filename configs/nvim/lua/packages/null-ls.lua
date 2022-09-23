local function install(use)
  use 'jose-elias-alvarez/null-ls.nvim'
end

local function setup()
  local null_ls = require('null-ls')
  null_ls.setup({
    sources = {
      -- null_ls.builtins.completion.spell,
      null_ls.builtins.code_actions.eslint_d,
      null_ls.builtins.code_actions.gitsigns,
      null_ls.builtins.code_actions.refactoring,
      null_ls.builtins.code_actions.shellcheck,

      null_ls.builtins.diagnostics.actionlint,
      null_ls.builtins.diagnostics.eslint_d,
      null_ls.builtins.diagnostics.ansiblelint,
      null_ls.builtins.diagnostics.commitlint,
      null_ls.builtins.diagnostics.gitlint,
      null_ls.builtins.diagnostics.luacheck,
      null_ls.builtins.diagnostics.markdownlint,
      null_ls.builtins.diagnostics.checkmake,

      null_ls.builtins.formatting.eslint_d,
      null_ls.builtins.formatting.blue,
      null_ls.builtins.formatting.fixjson,
      null_ls.builtins.formatting.lua_format,
      null_ls.builtins.formatting.markdownlint,
      null_ls.builtins.formatting.prettier,

      null_ls.builtins.hover.dictionary,
    },
  })
end

return {
  install = install,
  setup = setup,
}
