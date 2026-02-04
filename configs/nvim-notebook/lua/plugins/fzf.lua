-- fzf-lua - File and note navigation
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>f", group = "+fzf" },

    { "<leader>ff", group = "Files & Buffers" },
    { "<leader>ffp", ":lua require('fzf-lua').files()<CR>", desc = "Search in files" },
    { "<leader>ffb", ":lua require('fzf-lua').buffers()<CR>", desc = "Search in buffers" },
    { "<leader>ffq", ":lua require('fzf-lua').quickfix()<CR>", desc = "Search in quickfix" },
    { "<leader>ffh", ":lua require('fzf-lua').oldfiles()<CR>", desc = "Search in opened files history" },
    { "<leader>ffl", ":lua require('fzf-lua').blines()<CR>", desc = "Search in buffer lines" },
    { "<leader>ffL", ":lua require('fzf-lua').loclist()<CR>", desc = "Search in location list" },

    { "<leader>fs", group = "Search" },
    { "<leader>fsg", ":lua require('fzf-lua').grep()<CR>", desc = "Search" },
    { "<leader>fsl", ":lua require('fzf-lua').grep({resume=true})<CR>", desc = "Search last pattern again" },
    { "<leader>fsc", ":lua require('fzf-lua').grep_cword()<CR>", desc = "Search the word under cursor" },
    { "<leader>fsC", ":lua require('fzf-lua').grep_cWORD()<CR>", desc = "Search the WORD under cursor" },
    { "<leader>fsv", ":lua require('fzf-lua').grep_visual()<CR>", desc = "Search the visual selection" },
    { "<leader>fsb", ":lua require('fzf-lua').grep_curbuf()<CR>", desc = "Live grep in the current buffer" },
    { "<leader>fsp", ":lua require('fzf-lua').live_grep()<CR>", desc = "Live grep in the current project" },

    { "<leader>fl", group = "LSP" },
    { "<leader>flr", "<cmd>lua require('fzf-lua').lsp_references()<CR>", desc = "Search for references (backlinks)" },
    { "<leader>flf", "<cmd>lua require('fzf-lua').lsp_definitions()<CR>", desc = "Search for definitions" },
    { "<leader>fls", "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", desc = "Search for document symbols" },
    { "<leader>flS", "<cmd>lua require('fzf-lua').lsp_workspace_symbols()<CR>", desc = "Search for workspace symbols" },
    { "<leader>fla", "<cmd>lua require('fzf-lua').lsp_code_actions()<CR>", desc = "Search for code actions" },
    { "<leader>fld", "<cmd>lua require('fzf-lua').lsp_document_diagnostics()<CR>", desc = "Search for document diagnostics" },

    { "<leader>fm", group = "Misc" },
    { "<leader>fmb", "<cmd>lua require('fzf-lua').builtin()<CR>", desc = "fzf-lua builtin methods" },
    { "<leader>fmt", "<cmd>lua require('fzf-lua').help_tags()<CR>", desc = "help tags" },
    { "<leader>fmc", "<cmd>lua require('fzf-lua').colorschemes()<CR>", desc = "color schemes" },
    { "<leader>fmr", "<cmd>lua require('fzf-lua').commands()<CR>", desc = "commands" },
    { "<leader>fmh", "<cmd>lua require('fzf-lua').command_history()<CR>", desc = "commands history" },
    { "<leader>fmm", "<cmd>lua require('fzf-lua').marks()<CR>", desc = "marks" },
    { "<leader>fmk", "<cmd>lua require('fzf-lua').keymaps()<CR>", desc = "keymaps" },

    { "<leader>fg", group = "Git" },
    { "<leader>fgf", "<cmd>lua require('fzf-lua').git_files()<CR>", desc = "Search in git ls-files" },
    { "<leader>fgs", "<cmd>lua require('fzf-lua').git_status()<CR>", desc = "Search in git status" },
    { "<leader>fgc", "<cmd>lua require('fzf-lua').git_commits()<CR>", desc = "Search in git commit log" },
    { "<leader>fgb", "<cmd>lua require('fzf-lua').git_branches()<CR>", desc = "Search in git branches" },
  },
  opts = {
    winopts = {
      height = 0.85,
      width = 0.80,
      row = 0.35,
      col = 0.50,
      border = "rounded",
      preview = {
        border = "rounded",
        wrap = "wrap",
        layout = "vertical",
        vertical = "down:60%",
      },
    },
    keymap = {
      fzf = {
        ["ctrl-q"] = "select-all+accept",
      },
    },
    files = {
      fd_opts = [[--color=never --type f --hidden --follow --exclude .git --exclude node_modules]],
    },
    grep = {
      rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e]],
    },
  },
}
