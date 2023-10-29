local fn = vim.fn
local cmd = vim.cmd
local api = vim.api
local keymap = vim.keymap

local M = {}

function install()
  local navigation_map = {
      left = {
          vim = 'h',
          tmux = 'L',
      },
      right = {
          vim = 'l',
          tmux = 'R',
      },
      up = {
          vim = 'k',
          tmux = 'U',
      },
      down = {
          vim = 'j',
          tmux = 'D',
      },
  }

  function M.navigate(direction)
    return function()
      if navigation_map[direction] == nil then
          print('Unknown direction to navigate to "'..direction..'"')
          return nil
      end

      local win_num_before = fn.winnr()
      cmd('execute "wincmd ' .. navigation_map[direction].vim..'"')

        -- if current window id and before the navigation are the same,
        -- than we are at the edge of vim panes and should try tmux navigation
      if fn.winnr() == win_num_before then
        cmd('silent ! tmux select-pane -' .. navigation_map[direction].tmux)
      end

      -- empty status line
      -- cmd('echo')
    end
  end
end

local function post_setup()
  keymap.set('n', '<S-Down>', M.navigate('down'), { noremap = true })
  keymap.set('n', '<S-Up>', M.navigate('up'), { noremap = true})
  keymap.set('n', '<S-Right>', M.navigate('right'), { noremap = true})
  keymap.set('n', '<S-Left>', M.navigate('left'), { noremap = true})
end

return {
  install = install,
  post_setup = post_setup,
}
