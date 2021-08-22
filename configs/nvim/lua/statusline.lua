local opt = vim.opt

local status_left = ' %f:%m%r | %y'
local status_right = ' %= | %l,%c | %p%% ' 
local cbs = {}

function render(content)
  local s = ''
  s = s .. status_left .. ' | '

  for k, cb in ipairs(cbs) do
    s = s .. cb() .. ' | '
  end

  s = s .. '%=' .. status_right
  return s
end

function start() 
  opt.statusline  = "%!luaeval('render()')"
end

function add(cb)
  table.insert(cbs, cb)
end

function setup()
  start()
end

return { setup = setup, add = add }
