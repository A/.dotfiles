-- Editor options optimized for note-taking

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Line wrapping (soft wrap for prose)
opt.wrap = true
opt.linebreak = true
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- No concealing - show raw markdown
opt.conceallevel = 0

-- Spell checking disabled (causes underlines on wiki links with proper nouns)
opt.spell = false

-- Split behavior
opt.splitright = true
opt.splitbelow = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- Undo & backup
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Update time
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }

-- Fill chars
opt.fillchars = {
  eob = " ",
  fold = " ",
}

-- Markdown-specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    -- Wiki link syntax (better than treesitter's underlined version)
    vim.cmd([[syn region markdownWikiLink matchgroup=markdownLinkDelimiter start='\[\[' end='\]\]' contains=markdownUrl keepend oneline concealends]])
    vim.cmd([[syn match markdownTag "#[0-9A-Za-z:._]\+"]])
  end,
})

-- Auto-save on focus lost (only for existing files)
vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  callback = function()
    local file = vim.fn.expand("%:p")
    if vim.bo.modified and vim.bo.buftype == "" and vim.fn.filereadable(file) == 1 then
      vim.cmd("silent! write")
    end
  end,
})

-- Auto-save when leaving buffer (only for existing files)
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*.md",
  callback = function()
    local file = vim.fn.expand("%:p")
    if vim.bo.modified and vim.bo.buftype == "" and vim.fn.filereadable(file) == 1 then
      vim.cmd("silent! write")
    end
  end,
})
