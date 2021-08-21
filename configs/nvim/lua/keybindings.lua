local wk = require("which-key")
local g = vim.g      -- a table to access global variables

g.mapleader = ' '

local keys = {
  l = {
    name = 'LSP',
    a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Select a code action' },
    d = {
      name = 'Diagnostic actions..',
      d = { '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', 'Open diagnostics window for current line' },
      e = {'<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', 'Go to previous diagnostic'},
      n = {'<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', 'Go to next diagnostic'},
    },
    E = {'<Cmd>lua vim.lsp.buf.declaration()<CR>', 'Jump to symbol declaration'},
    e = {'<Cmd>lua vim.lsp.buf.definition()<CR>', 'Jump to symbol definition'},
    f = {"<cmd>lua vim.lsp.buf.formatting()<CR>", 'Format the current buffer'},
    h = {'<Cmd>lua vim.lsp.buf.hover()<CR>', 'Display hover information for symbol'},
    H = {'<Cmd>lua vim.lsp.buf.hover();vim.lsp.buf.hover()<CR>', 'Jump into hover information for symbol'},
    i = {'<cmd>lua vim.lsp.buf.implementation()<CR>', 'List implementations for symbol'},
    l = {'<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', 'Set location list'},
    r = {'<cmd>lua vim.lsp.buf.references()<CR>', 'List references for symbol'},
    R = {'<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename all symbol references'},
    s = {'<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Display signature information for symbol'},
    t = {'<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Jump to symbol type definition'},
    w = {
      name = 'Workspace actions...',
      a = {'<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add folder to workspace'},
      r = {'<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove folder from workspace'},
      l = {'<cmd>lua print()vim.inspect()vim.lsp.buf.list_workspace_folders()<CR>', 'List folders in workspace'},
    },
  },
  f = {
    name = 'FZF',
    f = {
      name = 'Files & Buffers',
      p = { "<cmd>lua require('fzf-lua').files()<CR>", 'Search in files'},
      b = { "<cmd>lua require('fzf-lua').buffers()<CR>", 'Search in buffers'},
      q = { "<cmd>lua require('fzf-lua').quickfix()<CR>", 'Search in quickfix'},
      h = { "<cmd>lua require('fzf-lua').oldfiles()<CR>", 'Search in opened files history'},
      l = { "<cmd>lua require('fzf-lua').loclist()<CR>", 'Search in location list'},
    },
    s = {
      name = 'Search',
      g = { "<cmd>lua require('fzf-lua').grep()<CR>", 'Search' },
      l = { "<cmd>lua require('fzf-lua').grep_last()<CR>", 'Search last pattern again' },
      c = { "<cmd>lua require('fzf-lua').grep_cword()<CR>", 'Search the word under cursor' },
      C = { "<cmd>lua require('fzf-lua').grep_cWORD()<CR>", 'Search the WORD under cursor' },
      v = { "<cmd>lua require('fzf-lua').grep_visual()<CR>", 'Search the visual selection' },
      b = { "<cmd>lua require('fzf-lua').grep_curbuf()<CR>", 'Live grep in the current buffer' },
      p = { "<cmd>lua require('fzf-lua').live_grep()<CR>", 'Live grep in the current project' },
    },
    g = {
      name = 'Git',
      f = { "<cmd>lua require('fzf-lua').git_files()<CR>", 'Search in git ls-files' },
      s = { "<cmd>lua require('fzf-lua').git_status()<CR>", 'Search in git status' },
      c = { 
        name = "Search in git commit log",
        c = { "<cmd>lua require('fzf-lua').git_commits()<CR>", 'Search in git commit log' },
        b = { "<cmd>lua require('fzf-lua').git_bcommits()<CR>", 'Search in git commit log for a buffer' },
      },
      b = { "<cmd>lua require('fzf-lua').git_branch()<CR>", 'Search in git branches' },
    },
    l = {
      name = 'LSP',
      r = { "<cmd>lua require('fzf-lua').lsp_references()<CR>", 'Search for references' },
      d = { "<cmd>lua require('fzf-lua').lsp_definitions()<CR>", 'Search for definitions' },
      D = { "<cmd>lua require('fzf-lua').lsp_declarations()<CR>", 'Search for declarations' },
      t = { "<cmd>lua require('fzf-lua').lsp_typedefs()<CR>", 'Search for type definitions' },
      i = { "<cmd>lua require('fzf-lua').lsp_implementations()<CR>", 'Search for implementations' },
      s = { "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", 'Search for document symbols' },
      S = { "<cmd>lua require('fzf-lua').lsp_workspace_symbols()<CR>", 'Search for workspace symbols' },
      a = { "<cmd>lua require('fzf-lua').lsp_code_actions()<CR>", 'Search for code actions' },
      d = { "<cmd>lua require('fzf-lua').lsp_document_diagnostics()<CR>", 'Search for document diagnostics' },
      D = { "<cmd>lua require('fzf-lua').lsp_workspace_diagnostics()<CR>", 'Search for workspace diagnostics' },
    },
    m = {
      name = 'Misc',
      b = { "<cmd>lua require('fzf-lua').builtin()<CR>", 'fzf-lua builtin methods' },
      h = { "<cmd>lua require('fzf-lua').help_tags()<CR>", 'help tags' },
      m = { "<cmd>lua require('fzf-lua').man_pages()<CR>", 'man pages' },
      c = { "<cmd>lua require('fzf-lua').colorschemes()<CR>", 'color schemes' },
      r = { "<cmd>lua require('fzf-lua').commands()<CR>", 'commands' },
      h = { "<cmd>lua require('fzf-lua').command_history()<CR>", 'commands history' },
      H = { "<cmd>lua require('fzf-lua').search_history()<CR>", 'search history' },
      m = { "<cmd>lua require('fzf-lua').marks()<CR>", 'marks' },
      R = { "<cmd>lua require('fzf-lua').registers()<CR>", 'registers' },
      k = { "<cmd>lua require('fzf-lua').keymaps()<CR>", 'keymaps' },
    }
  },
  n = {
    name = 'Navigation',
    o = { "<cmd>CHADopen<CR>", 'Open navigation' },
  },
}

wk.register(keys, { prefix = "<leader>", mode = 'n' })
