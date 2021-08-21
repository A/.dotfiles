local opt = vim.opt

opt.colorcolumn = '120'
opt.completeopt = 'preview'
opt.cursorline = true
opt.encoding = 'utf-8'
opt.expandtab = true
opt.hidden = true
opt.ignorecase = true
opt.laststatus = 2
opt.lcs = 'eol:·'
opt.list = true
opt.mouse = 'a'
opt.wrap = false
opt.number = true
opt.scrolloff = 8
opt.shiftwidth = 2
opt.showtabline = 0
opt.spelllang = {'en_us', 'ru'}
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.updatetime = 750
opt.wildignore = {'package-lock.json','yarn.lock'}
opt.grepprg = 'rg --color=never --vimgrep'
