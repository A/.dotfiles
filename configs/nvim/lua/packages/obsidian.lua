local cmd = vim.cmd
local keymap = vim.keymap
local ui = vim.ui
local fn = vim.fn

local keys = {
  o = {
    name = 'Obsidian',
    r = { "<cmd>lua require('packages/nvim-obsidian/lib').rename()<CR>", "Rename a note" },
    b = { "<cmd>ObsidianBacklinks<CR>", "Show backlinks" },
    h = { "<cmd>lua require('packages/nvim-obsidian/lib').hover_link()<CR>", "Preview a link under cursor" },
    s = { "<cmd>ObsidianSearch<CR>", "Search notes" },
    p = { "<cmd>ObsidianQuickSwitch<CR>", "Quick switch to a note" },
    t = { "<cmd>ObsidianTemplate<CR>", "Insert Template" },
    n = { "<cmd>lua require('packages/obsidian').new_note()<CR>", "Create a new note" },
    x = { "<cmd>lua require('packages/nvim-obsidian/lib').open_link()<CR>", "Open a link under cursor" },
  }
}

local function new_note()
  ui.input({ prompt = 'Enter a new note name: ' }, function(input)
    cmd(":ObsidianNew "..input)
  end)
end

local function install(use)


  use {
    "epwalsh/obsidian.nvim",
    -- lazy = true,
    -- event = { "BufReadPre " .. vim.fn.expand "~" .. "/Dev/@A/notes/**.md" },
    config = function ()
      require('obsidian').setup({
        dir = "~/Dev/@A/notes",
        -- log_level = vim.log.levels.DEBUG,
        daily_notes = {
          folder = "daily",
          date_format = "%Y%m%d"
        },
        completion = {
          nvim_cmp = true,
          min_chars = 2,
          new_notes_location = "current_dir"
        },

        note_id_func = function(title)
          return title
        end,
        disable_frontmatter = true,
        templates = {
          subdir = "templates",
          date_format = "%Y-%m-%d-%a",
          time_format = "%H:%M",
        },

        follow_url_func = function(url)
          -- Open the URL in the default web browser.
          -- vim.fn.jobstart({"open", url})  -- Mac OS
          fn.jobstart({"xdg-open", url})  -- linux
        end,

        -- Optional, set to true if you use the Obsidian Advanced URI plugin.
        -- https://github.com/Vinzent03/obsidian-advanced-uri
        use_advanced_uri = true,

        -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
        open_app_foreground = false,

        -- Optional, by default commands like `:ObsidianSearch` will attempt to use
        -- telescope.nvim, fzf-lua, and fzf.nvim (in that order), and use the
        -- first one they find. By setting this option to your preferred
        -- finder you can attempt it first. Note that if the specified finder
        -- is not installed, or if it the command does not support it, the
        -- remaining finders will be attempted in the original order.
        finder = "fzf-lua",
      })


      -- Optional, override the 'gf' keymap to utilize Obsidian's search functionality.
      -- see also: 'follow_url_func' config option above.
      vim.keymap.set("n", "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gf"
        end
      end, { noremap = false, expr = true })

    end,
  }
end

local function post_setup()
  vim.cmd(":au! BufNewFile,BufRead *.md set ft=lsp_markdown")
  vim.cmd(":syn region markdownWikiLink matchgroup=markdownLinkDelimiter start='\\[\\[' end='\\]\\]' contains=markdownLinkUrl keepend oneline concealends")

  local cwd = fn.getcwd()
  -- TODO: ignore if current buffer is not empty
  if cwd:find('^/home/a8ka/Dev/@A/notes') ~= nil then
    cmd.edit('Index.md')
  end
end


return {
  new_note = new_note,
  keys = keys,
  install = install,
  post_setup = post_setup,
}
