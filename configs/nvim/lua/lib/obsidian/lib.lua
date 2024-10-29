local cmd = vim.cmd
local api = vim.api
local ui = vim.ui
local fn = vim.fn
local lsp = vim.lsp

local function table_slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced + 1] = tbl[i]
  end

  return sliced
end

local function get_file_under_cursor()
  local filename = fn.expand("<cfile>") .. ".md"
  local path = fn.system('find . -name "' .. filename .. '"')
  return path:gsub("\n", "")
end

local function read_file_content(path)
  local content = fn.system('cat "' .. path .. '"')
  local raw_lines = lsp.util.convert_input_to_markdown_lines(content)
  local lines = raw_lines
  if raw_lines[1] == "---" then
    local content_start
    local pointer = 1
    for i, l in pairs(raw_lines) do
      if pointer ~= 1 and l == "---" then
        content_start = pointer + 1
      end
      pointer = pointer + 1
    end
    lines = table_slice(raw_lines, content_start, pointer)
  end

  if not next(lines) then
    lines = nil
  end

  return lines
end

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

  if basename == nil then
    return
  end

  ui.input({ prompt = "Enter a new name for " .. basename .. ": " }, function(input)
    cmd(":w " .. input .. ".md")
    cmd(
      '!find . -name "*.md" -type f -exec sed -i "" "s/\\[\\['
        .. basename
        .. "\\([ \\t]*\\|[ \\t]*.*\\)\\{0,1\\}\\]\\]/[["
        .. input
        .. '\\1]]/g" {} +'
    )
    remove_cur_note()
  end)
end

local function show_backlinks()
  local basename = get_cur_note_name()

  if basename == nil then
    return
  end

  cmd('silent! grep "\\[\\[' .. basename .. '(\\s*\\|.*)?\\]\\]"')
  cmd("TroubleToggle quickfix")
end

local function hover_link()
  local file = get_file_under_cursor()
  local lines = read_file_content(file)

  if lines == nil then
    return
  end

  local ok = pcall(lsp.util.open_floating_preview, lines, "markdown")

  if not ok then
    print("Nothing to preview...")
  end
end

local function open_link()
  local file = get_file_under_cursor()
  fn.system('cat "' .. file .. '" | rg "link: (.*)" -r \'$1\' | xargs open')
end

return {
  rename = rename,
  show_backlinks = show_backlinks,
  hover_link = hover_link,
  open_link = open_link,
}
