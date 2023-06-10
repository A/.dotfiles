local keys = {
  m = {
    name = "markdown",
    p = { "<cmd>Glow keep<CR>", "Preview" },
    h = { "<cmd>Glow preview<CR>", "Hover Preview" },
    s = { "<cmd>Glow split<CR>", "Split Preview" },
  }
}

local function install(use)
  -- use {"ellisonleao/glow.nvim"}
  use {"lnc3l0t/glow.nvim", branch = "advanced_window"}
end

local function setup()
  require("glow").setup({
    in_place = true,
    -- pager = true,
  })
end


return {
  install = install,
  setup = setup,
  keys = keys,
}
