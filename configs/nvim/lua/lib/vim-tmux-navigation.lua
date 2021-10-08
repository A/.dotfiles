local M = {}

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
    if navigation_map[direction] == nil then
        print('Unknown direction to navigate to "'..direction..'"')
        return nil
    end

    local win_num_before = vim.fn.winnr()
	vim.cmd('execute "wincmd ' .. navigation_map[direction].vim..'"')
    -- if current window id and before the navigation are the same,
    -- than we are at the edge of vim panes and should try tmux navigation
	if vim.fn.winnr() == win_num_before then
		vim.cmd('silent ! tmux select-pane -' .. navigation_map[direction].tmux)
	end

    -- empty status line
    vim.cmd('echo')
end

return M

