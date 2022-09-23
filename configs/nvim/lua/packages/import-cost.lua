local function install(use)
  use({ "yardnsm/vim-import-cost", run = "npm install" })
end

return {
  install = install,
}
