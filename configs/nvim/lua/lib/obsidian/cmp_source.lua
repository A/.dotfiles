local Source = {}

-- function table.empty (self)
--     for _, _ in pairs(self) do
--         return false
--     end
--     return true
-- end

Source.new = function()
  local self = setmetatable({}, { __index = Source })
  return self
end

function Source:is_available()
  return vim.bo.filetype == "markdown"
end

function Source.get_debug_name()
  return "obsidian"
end

-- Return keyword pattern for triggering completion. (Optional)
-- If this is ommited, nvim-cmp will use default keyword pattern. See |cmp-config.completion.keyword_pattern|
-- @return string
function Source:get_keyword_pattern()
  return '\\[\\[\\a\\+'
end

function Source:complete(request, callback)
  print(request)
  local word = string.sub(request.context.cursor_before_line, request.offset)
  -- remove first [[
  word = word:sub(3)

  local cmd = "rg --files | rg --no-line-number " .. word

  local handle_file_list = io.popen(cmd)

  local words = handle_file_list:lines()
  local t, i = {}, 0

  for filename in words do
    i = i + 1
    local name = filename:match("(.+)%..+$")
    if name ~= nil then
      if string.match(filename, ".md") then
        t[i] = {
          label = "[[" .. name .. "]]",
          filename = filename,
          documentation = documentation,
        }
      else
        t[i] = { label = "![[" .. filename .. "]]" }
      end
    end
  end
  handle_file_list:close()

  if #t == 0 then
    return callback()
  end

  callback(t)
end

function Source:resolve(completion_item, callback)
  if completion_item.filename == nil then
    return callback(completion_item)
  end

  local cmd = "cat " .. '"' .. completion_item.filename .. '"'
  local handle_file_content = io.popen(cmd)

  -- completion_item.documentation = cmd
  if handle_file_content ~= nil then
    completion_item.documentation = handle_file_content:read("*a")
    handle_file_content:close()
  end

  callback(completion_item)
end

local source = Source.new()

return {
  source = source,
}
