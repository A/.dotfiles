local table_merge = require('lib/utils/table_merge').table_merge

local keys = {

}

local function setup_cmp()
  local cmp = require "cmp"
  local obsidian_source = require('packages/nvim-obsidian/cmp_source').source
  cmp.register_source('obsidian', obsidian_source)

  local sources = {{ name = "obsidian" }}

  for _, source in pairs(cmp.get_config().sources) do
    if source.name ~= "obsidian" then
      table.insert(sources, source)
    end
  end

  cmp.setup.buffer({ sources = sources })
end

local function setup()
    require('packages/nvim-obsidian/md_buffer_au')
    setup_cmp()
end


return {
  setup = setup,
  keys = keys,
}
