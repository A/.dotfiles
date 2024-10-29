return {
  'rcarriga/nvim-notify',
  event = "VimEnter",
  opts = {
    timeout = 3000,
  },
  config = function ()
    require("notify").setup()
  end
}
