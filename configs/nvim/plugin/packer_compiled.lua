-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/a8ka/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/a8ka/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/a8ka/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/a8ka/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/a8ka/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    config = { "\27LJ\2\nH\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tload luasnip/loaders/from_vscode\frequire\0" },
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/LuaSnip",
    wants = { "friendly-snippets" }
  },
  ["diagnosticls-configs-nvim"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/diagnosticls-configs-nvim"
  },
  ["editorconfig-vim"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/editorconfig-vim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/friendly-snippets"
  },
  ["fzf-lua"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/fzf-lua"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/lsp-status.nvim"
  },
  ["lualine-lsp-progress"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/lualine-lsp-progress"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  neorg = {
    config = { "\27LJ\2\nﾃ\2\0\2\b\0\t\0\0169\2\0\1'\4\1\0005\5\6\0004\6\5\0005\a\2\0>\a\1\0065\a\3\0>\a\2\0065\a\4\0>\a\3\0065\a\5\0>\a\4\6=\6\a\0055\6\b\0B\2\4\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2\6n\1\0\0\1\3\0\0\14<C-Space>-core.norg.qol.todo_items.todo.task_cycle\1\3\0\0\bgtp/core.norg.qol.todo_items.todo.task_pending\1\3\0\0\bgtu.core.norg.qol.todo_items.todo.task_undone\1\3\0\0\bgtd,core.norg.qol.todo_items.todo.task_done\tnorg\22map_event_to_mode{\1\0\6\0\6\0\t'\0\0\0006\1\1\0'\3\2\0B\1\2\0029\2\3\1'\4\4\0003\5\5\0B\2\3\1K\0\1\0\0)core.keybinds.events.enable_keybinds\ron_event\20neorg.callbacks\frequire\r<Leader>饅1\1\0\a\0\16\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\f\0005\3\3\0004\4\0\0=\4\4\0034\4\0\0=\4\5\0035\4\t\0005\5\a\0005\6\6\0=\6\b\5=\5\n\4=\4\v\3=\3\r\0023\3\14\0=\3\15\2B\0\2\1K\0\1\0\thook\0\tload\1\0\0\21core.norg.dirman\vconfig\1\0\0\15workspaces\1\0\0\1\0\1\17my_workspace\18~/Dev/@A/norg\24core.norg.concealer\18core.defaults\1\0\0\nsetup\nneorg\frequire\0" },
    loaded = false,
    needs_bufread = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/opt/neorg"
  },
  nerdtree = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/nerdtree"
  },
  ["nerdtree-git-plugin"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/nerdtree-git-plugin"
  },
  ["nvim-comment"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17nvim_comment\frequire\0" },
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/nvim-comment"
  },
  ["nvim-compe"] = {
    config = { "\27LJ\2\n能2\0\0\5\0\14\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\0035\4\a\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\3=\3\r\2B\0\2\1K\0\1\0\vsource\vbuffer\1\0\1\rpriority\3申3\tpath\1\0\1\rpriority\3申3\rnvim_lsp\1\0\1\rpriority\33\fluasnip\1\0\0\1\0\2\rpriority\3ﾘ\4\tmenu\n[SNP]\1\0\5\14preselect\venable\15min_length\3\1\17autocomplete\2\fenabled\2\18documentation\2\nsetup\ncompe\frequire\0" },
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/nvim-compe",
    wants = { "LuaSnip" }
  },
  ["nvim-fzf"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/nvim-fzf"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-prisma"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/vim-prisma"
  },
  ["vim-trash-polka"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/vim-trash-polka"
  },
  ["which-key.nvim"] = {
    loaded = true,
    path = "/home/a8ka/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: nvim-compe
time([[Config for nvim-compe]], true)
try_loadstring("\27LJ\2\n能2\0\0\5\0\14\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\0035\4\a\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\3=\3\r\2B\0\2\1K\0\1\0\vsource\vbuffer\1\0\1\rpriority\3申3\tpath\1\0\1\rpriority\3申3\rnvim_lsp\1\0\1\rpriority\33\fluasnip\1\0\0\1\0\2\rpriority\3ﾘ\4\tmenu\n[SNP]\1\0\5\14preselect\venable\15min_length\3\1\17autocomplete\2\fenabled\2\18documentation\2\nsetup\ncompe\frequire\0", "config", "nvim-compe")
time([[Config for nvim-compe]], false)
-- Config for: nvim-comment
time([[Config for nvim-comment]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17nvim_comment\frequire\0", "config", "nvim-comment")
time([[Config for nvim-comment]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
try_loadstring("\27LJ\2\nH\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tload luasnip/loaders/from_vscode\frequire\0", "config", "LuaSnip")
time([[Config for LuaSnip]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType norg ++once lua require("packer.load")({'neorg'}, { ft = "norg" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/a8ka/.local/share/nvim/site/pack/packer/opt/neorg/ftdetect/norg.vim]], true)
vim.cmd [[source /home/a8ka/.local/share/nvim/site/pack/packer/opt/neorg/ftdetect/norg.vim]]
time([[Sourcing ftdetect script at: /home/a8ka/.local/share/nvim/site/pack/packer/opt/neorg/ftdetect/norg.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
