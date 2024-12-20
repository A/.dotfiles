local g = vim.g
local opt = vim.opt

g.mapleader = " "
g.markdown_fenced_languages = {
  "bash=sh",
  "css",
  "html",
  "javascript",
  "js=javascript",
  "json=javascript",
  "php",
  "python",
  "ruby",
  "rust",
  "sql",
  "ts=typescript",
  "typescript",
  "vim",
  -- 'dbml',
  "sass",
}
-- g.markdown_folding = 1

opt.backup = false
opt.clipboard = "unnamedplus"
opt.colorcolumn = "120"
opt.completeopt = { "menuone", "noinsert", "noselect" }
opt.cursorline = true
opt.encoding = "utf-8"
opt.expandtab = true
opt.grepprg = "rg --color=never --vimgrep"
opt.hidden = true
opt.ignorecase = true
opt.laststatus = 2
opt.lcs = "eol:·"
opt.list = true
opt.mouse = "a"
opt.mouse = "a"
opt.number = true
opt.rnu = true
opt.scrolloff = 8
opt.sessionoptions = "folds"
opt.shiftwidth = 2
opt.showtabline = 0
opt.spelllang = { "en_us", "ru" }
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.tabstop = 2
opt.termguicolors = false
opt.updatetime = 750
opt.viewoptions = "cursor,folds"
opt.wildignore = { "package-lock.json", "yarn.lock" }
opt.wrap = false
opt.writebackup = false
opt.termguicolors = true
opt.conceallevel = 0

-- opt.statuscolumn = " "
-- vim.wo.signcolumn = "yes"

opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = "v:lua.vim.treesitter.foldtext()"

-- opt.verbose = 2
-- opt.verbosefile = "/users/anton/.logs/nvim.log"

vim.cmd([[iabbrev <expr> ymd% strftime("%y%m%d")]])

-- vim.api.nvim_create_autocmd({ "insertenter" }, { command = "hi cursorline ctermbg=16" })
-- vim.api.nvim_create_autocmd({ "insertleave" }, { command = "hi cursorline ctermbg=none" })
--
vim.o.winbar = "  %{%v:lua.require'lib.filepath'.eval()%} %{%v:lua.require'nvim-navic'.get_location()%}"
