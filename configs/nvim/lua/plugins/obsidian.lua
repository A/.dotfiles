return {
  dir = "~/.config/nvim/lua/lib/obsidian/",
  enabled = false,
  ft = "markdown",
  dev = true,
  config = function()
    local obsidian = require("lib.obsidian.obsidian")
    obsidian.setup()
  end,
}
