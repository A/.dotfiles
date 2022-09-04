-- Auto-install packer if it hasn't been installed
local fn = vim.fn
local execute = vim.api.nvim_command


local function pre_install()
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    execute 'packadd packer.nvim'
  end
end

local function install(use)
  use 'wbthomason/packer.nvim'
end

return {
  pre_install = pre_install,
  install = install,
}
