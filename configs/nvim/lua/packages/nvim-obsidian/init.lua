local keys = {
  o = {
    name = 'Obsidian',
    r = { "<cmd>lua require('packages/nvim-obsidian/lib').rename()<CR>", "Rename Note" },
    b = { "<cmd>lua require('packages/nvim-obsidian/lib').show_backlinks()<CR>", "Show Backlinks" },
  }
}

local function install(use)
  use({
    'andrewferrier/vim-wrapping-softhard',
    config = function()
        require('wrapping').setup(opts)
    end,
  })
end

local function setup_cmp()
  local cmp = require("cmp")
  local obsidian_source = require('packages/nvim-obsidian/cmp_source').source
  cmp.register_source('obsidian', obsidian_source)

  local sources = {{ name = "obsidian" }}

  for _, source in pairs(cmp.get_config().sources) do
    if source.name ~= "obsidian" then
      table.insert(sources, source)
    end
  end

  cmp.setup.filetype('markdown', { sources = sources })
  -- cmp.setup.buffer({ sources = sources })
end

local function setup()
    setup_cmp()
    require('packages/nvim-obsidian/md_buffer_au')
    require('packages/nvim-obsidian/wikilinks')
end


return {
  install = install,
  setup = setup,
  keys = keys,
}
