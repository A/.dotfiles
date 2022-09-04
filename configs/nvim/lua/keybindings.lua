local wk = require("which-key")
local api = vim.api

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
  c = {
    name = 'Code Stuff',
    c = { "<cmd>CommentToggle<CR>", 'Comment' },
  },
}


wk.register(keys, { prefix = "<leader>", mode = 'n' })



api.nvim_set_keymap('n', '<S-Down>', ':lua require("lib/vim-tmux-navigation").navigate("down")<cr>', { noremap = true })
api.nvim_set_keymap('n', '<S-Up>', ':lua require("lib/vim-tmux-navigation").navigate("up")<cr>', { noremap = true })
api.nvim_set_keymap('n', '<S-Right>', ':lua require("lib/vim-tmux-navigation").navigate("right")<cr>', { noremap = true })
api.nvim_set_keymap('n', '<S-Left>', ':lua require("lib/vim-tmux-navigation").navigate("left")<cr>', { noremap = true })

