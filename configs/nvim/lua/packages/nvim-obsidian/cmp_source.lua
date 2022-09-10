local Source = {}

function table.empty (self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

Source.new = function()
    local self = setmetatable({}, { __index = Source })
    return self
end

function Source:is_available()
  return vim.bo.filetype == "markdown"
end

-- Return keyword pattern for triggering completion. (Optional)
-- If this is ommited, nvim-cmp will use default keyword pattern. See |cmp-config.completion.keyword_pattern|
-- @return string
function Source:get_keyword_pattern()
  return "\\w\\+"
end

function Source:complete(request, callback)
  local word = string.sub(request.context.cursor_before_line, request.offset)
  local cmd = "rg --files | rg "..word

  local pfile = io.popen(cmd)

  local words = pfile:lines()
  local t, i = {}, 0

  for filename in words do
    i = i + 1
    local name = filename:match("(.+)%..+$")
    if name ~= nil then
      if string.match(filename, ".md") then
        t[i] = { label = "[["..name.."]]" }
      else
        t[i] = { label = "![["..filename.."]]" }
      end
    end

  end

  if #t == 0 then
    return callback()
  end

  pfile:close()


  callback(t)
end

local source = Source.new()

return {
  source = source,
}
