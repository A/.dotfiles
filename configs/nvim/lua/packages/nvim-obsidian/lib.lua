local cmd = vim.cmd
local api = vim.api
local ui = vim.ui
-- local fs = vim.fs

local function get_basename(file)
  for k in string.gmatch(file, ".*/(.*)%.md$") do
    return k
  end
end

local function get_cur_note_name()
  local file = api.nvim_buf_get_name(0)
  return get_basename(file)
end

local function remove_cur_note()
  local file = api.nvim_buf_get_name(0)
  cmd(':!rm "' .. file .. '"')
end

local function rename()
  local basename = get_cur_note_name()

  if (basename == nil) then
    return
  end

  ui.input({ prompt = 'Enter a new name for ' .. basename ..': ' }, function(input)
    cmd(':w ' .. input .. '.md')
    cmd('!find . -name "*.md" -type f -exec sed -i "" "s/\\[\\[' .. basename .. '\\([ \\t]*\\|[ \\t]*.*\\)\\{0,1\\}\\]\\]/[[' .. input ..'\\1]]/g" {} +')
    remove_cur_note()
  end)
end

local function show_backlinks()
  local basename = get_cur_note_name()

  if (basename == nil) then
    return
  end

  cmd('silent! grep "\\[\\[' .. basename .. '(\\s*\\|.*)?\\]\\]"')
  cmd('TroubleToggle quickfix')
end

return {
  rename = rename,
  show_backlinks = show_backlinks,
}
