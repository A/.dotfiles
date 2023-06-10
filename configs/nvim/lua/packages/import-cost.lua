local api = vim.api

local function install(use)
  use({ "yardnsm/vim-import-cost", run = "npm install" })
end

local function post_setup()
  api.nvim_command(':highlight link ImportCostVirtualText Comment')
  api.nvim_command('au FileType typescript,typescriptreact,javascript,javascriptreact :silent! ImportCost')
end

return {
  install = install,
  post_setup = post_setup,
}
