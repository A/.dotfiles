local function install(use)
  use({
    "scalameta/nvim-metals",
    requires = { "nvim-lua/plenary.nvim" }
  })
end

local function setup()
  local metals_config = require("metals").bare_config()

  metals_config.settings = {
    showImplicitArguments = true,
    serverVersion = 'latest.snapshot',
  }
  local group = vim.api.nvim_create_augroup("metals", { clear = true })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = group,
    pattern = { "scala", "sbt", "java" },
    callback = function()
      require("metals").initialize_or_attach(metals_config)
    end,
  })
end

return {
  install = install,
  setup = setup,
}
