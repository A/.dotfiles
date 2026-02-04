-- Keymaps for note-taking

local map = vim.keymap.set

-- Vault path (ensure trailing slash)
local vault_path = vim.env.NOTES_DIR:gsub("/$", "") .. "/"

-- General
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })

-- Better movement with wrapped lines
map("n", "j", "gj", { desc = "Move down (visual line)" })
map("n", "k", "gk", { desc = "Move up (visual line)" })
map("n", "0", "g0", { desc = "Start of visual line" })
map("n", "$", "g$", { desc = "End of visual line" })

-- Note navigation (FZF)
map("n", "<leader>nf", function()
  require("fzf-lua").files({ cwd = vault_path })
end, { desc = "Find notes" })

map("n", "<leader>ng", function()
  require("fzf-lua").live_grep({ cwd = vault_path })
end, { desc = "Grep notes" })

map("n", "<leader>nr", function()
  require("fzf-lua").oldfiles({ cwd = vault_path })
end, { desc = "Recent notes" })

-- New note
map("n", "<leader>nn", function()
  local title = vim.fn.input("Note title: ")
  if title ~= "" then
    local filename = title:gsub(" ", "-"):lower() .. ".md"
    vim.cmd("edit " .. vault_path .. filename)
    -- Insert title as H1 if file is new
    if vim.fn.filereadable(vim.fn.expand("%")) == 0 then
      vim.api.nvim_buf_set_lines(0, 0, 0, false, { "# " .. title, "", "" })
      vim.cmd("normal! G")
    end
  end
end, { desc = "New note" })

-- Daily note
map("n", "<leader>nd", function()
  local date = os.date("%Y-%m-%d")
  local daily_path = vault_path .. "daily/"
  vim.fn.mkdir(daily_path, "p")
  vim.cmd("edit " .. daily_path .. date .. ".md")
  -- Insert date as H1 if file is new
  if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
    local formatted_date = os.date("%A, %B %d, %Y")
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { "# " .. formatted_date, "", "" })
    vim.cmd("normal! G")
  end
end, { desc = "Daily note" })

-- Follow/create link under cursor
map("n", "gf", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  -- Find wiki link [[...]] under cursor
  local start_pos, end_pos, link = nil, nil, nil
  for s, l, e in line:gmatch("()%[%[(.-)%]%]()") do
    if col >= s - 1 and col < e - 1 then
      start_pos, link, end_pos = s, l, e
      break
    end
  end

  if link then
    -- Remove any alias (text after |)
    link = link:gsub("|.*$", "")
    -- Add .md extension if not present
    if not link:match("%.md$") then
      link = link .. ".md"
    end

    -- Search for the file in vault
    local found = vim.fn.globpath(vault_path, "**/" .. link, false, true)
    if #found > 0 then
      vim.cmd("edit " .. found[1])
    else
      -- Create new file
      vim.cmd("edit " .. vault_path .. link)
      -- Insert title
      local title = link:gsub("%.md$", ""):gsub("-", " ")
      title = title:sub(1, 1):upper() .. title:sub(2)
      vim.api.nvim_buf_set_lines(0, 0, 0, false, { "# " .. title, "", "" })
      vim.cmd("normal! G")
    end
  else
    -- Fallback to normal gf
    vim.cmd("normal! gf")
  end
end, { desc = "Follow/create link" })

-- Insert link
map("n", "<leader>nl", function()
  require("fzf-lua").files({
    cwd = vault_path,
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          local file = selected[1]
          -- Remove path and extension for wiki link
          local name = vim.fn.fnamemodify(file, ":t:r")
          vim.api.nvim_put({ "[[" .. name .. "]]" }, "c", true, true)
        end
      end,
    },
  })
end, { desc = "Insert link" })

-- Show backlinks to current file
map("n", "<leader>nb", function()
  local filename = vim.fn.expand("%:t:r") -- current filename without extension
  require("fzf-lua").grep({
    cwd = vault_path,
    search = "\\[\\[" .. filename .. "(\\]\\]|\\|)",
    no_esc = true,
  })
end, { desc = "Show backlinks" })

-- Rename file and update all references
map("n", "<leader>nr", function()
  local current_file = vim.fn.expand("%:p")
  local current_name = vim.fn.expand("%:t:r") -- filename without extension
  local vault = vault_path

  local new_name = vim.fn.input("New name: ", current_name)
  if new_name == "" or new_name == current_name then
    return
  end

  -- Save current file first
  vim.cmd("silent! write")

  -- New file path
  local current_dir = vim.fn.expand("%:p:h")
  local new_file = current_dir .. "/" .. new_name .. ".md"

  -- Update references in all markdown files
  local cmd = string.format(
    "find %s -name '*.md' -exec sed -i 's/\\[\\[%s\\]\\]/[[%s]]/g' {} \\;",
    vim.fn.shellescape(vault),
    current_name,
    new_name
  )
  vim.fn.system(cmd)

  -- Also update references with aliases [[old|alias]] -> [[new|alias]]
  local cmd2 = string.format(
    "find %s -name '*.md' -exec sed -i 's/\\[\\[%s|/[[%s|/g' {} \\;",
    vim.fn.shellescape(vault),
    current_name,
    new_name
  )
  vim.fn.system(cmd2)

  -- Rename the file
  vim.fn.rename(current_file, new_file)

  -- Open the new file
  vim.cmd("edit " .. new_file)

  -- Update the heading if it matches old name
  local first_line = vim.fn.getline(1)
  if first_line == "# " .. current_name then
    vim.fn.setline(1, "# " .. new_name)
  end

  vim.notify("Renamed to " .. new_name .. " and updated references", vim.log.levels.INFO)
end, { desc = "Rename file + references" })

-- Toggle checkbox
map("n", "<leader>nt", function()
  local line = vim.api.nvim_get_current_line()
  local new_line
  if line:match("%- %[ %]") then
    new_line = line:gsub("%- %[ %]", "- [x]", 1)
  elseif line:match("%- %[x%]") then
    new_line = line:gsub("%- %[x%]", "- [ ]", 1)
  elseif line:match("^%s*%-") then
    new_line = line:gsub("^(%s*)%-", "%1- [ ]", 1)
  else
    return
  end
  vim.api.nvim_set_current_line(new_line)
end, { desc = "Toggle checkbox" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
