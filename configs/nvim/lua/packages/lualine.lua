local function use_hook(use)
  use { 'hoob3rt/lualine.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons', opt = true,
    },
  }
end

return {
  use_hook = use_hook,
}

