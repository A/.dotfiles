local function setup_cmp()
  local cmp = require("cmp")
  local obsidian_source = require("lib/obsidian/cmp_source").source
  cmp.register_source("obsidian", obsidian_source)

  local sources = { { name = "obsidian" } }

  for _, source in pairs(cmp.get_config().sources) do
    if source.name ~= "obsidian" then
      table.insert(sources, source)
    end
  end

  cmp.setup.filetype("markdown", { sources = sources })
  cmp.setup.buffer({ sources = sources })
end

local function setup()
  print(123123)
  setup_cmp()
  require("lib/obsidian/md_buffer_au")
  -- require("lib/obsidian/wikilinks")
end

return {
  setup = setup,
  hover_link = require("lib/obsidian/lib").hover_link,
  open_link = require("lib/obsidian/lib").open_link,
}
