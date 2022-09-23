local keys = {
  T = {
    name = "Trouble",
    T = { '<cmd>TroubleToggle<cr>', 'Toggle' },
    D = { '<cmd>TroubleToggle workspace_diagnostics<cr>', 'Workspace Diagnostics' },
    d = { '<cmd>Trouble document_diagnostics<cr>', 'Document Diagnostics' },
    q = { '<cmd>Trouble quickfix<cr>', 'Quickfix' },
    l = { '<cmd>Trouble loclist<cr>', 'Loclist' },
    r = { '<cmd>Trouble lsp_references<cr>', 'References' },
  },
}

local function install(use)
  use 'folke/trouble.nvim'
  use 'kyazdani42/nvim-web-devicons'
end


local function setup()
  require('trouble').setup({})
end


return {
  install = install,
  setup = setup,
  keys = keys,
}
