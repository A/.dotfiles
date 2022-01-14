local compe = require('compe')

local Source = {}

function Source.new(client, source)
	return setmetatable({}, { __index = Source })
end

function Source.get_metadata(_)
  print 'get_metadata'
  return {
    priority = 10000,
    dup = 1,
    menu = '[PAGE]',
  }
end

function Source.determine(_, context)
  print 'determine'
  return compe.helper.determine(context)
end

function Source.complete(self, args)
  print 'complete'
  local items = {
    { word = 'abcd'; abbr = 'abcd'; kind = 'abcd'; filter_text = 'abcd' };
  }
  args.callback({
    items = items,
    incomplete = true
  })
end

return Source.new()
