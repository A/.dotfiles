-- markdown-oxide LSP for wiki links, completions, and backlinks
return {
  "saghen/blink.cmp",
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Enable dynamic registration for code actions
    capabilities.workspace = capabilities.workspace or {}
    capabilities.workspace.didChangeWatchedFiles = {
      dynamicRegistration = true,
    }

    -- Use new vim.lsp.config API (Neovim 0.11+)
    vim.lsp.config.markdown_oxide = {
      cmd = { "markdown-oxide" },
      filetypes = { "markdown" },
      root_markers = { ".obsidian", ".vault", ".git" },
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        -- Refresh codelens on certain events
        if client.server_capabilities.codeLensProvider then
          vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
            buffer = bufnr,
            callback = function()
              vim.lsp.codelens.refresh({ bufnr = bufnr })
            end,
          })
        end
      end,
    }

    vim.lsp.enable("markdown_oxide")

    -- Daily note commands
    vim.api.nvim_create_user_command("Daily", function(opts)
      local arg = opts.args:lower()
      local date
      if arg == "today" or arg == "" then
        date = os.date("%Y-%m-%d")
      elseif arg == "tomorrow" then
        date = os.date("%Y-%m-%d", os.time() + 86400)
      elseif arg == "yesterday" then
        date = os.date("%Y-%m-%d", os.time() - 86400)
      else
        date = arg
      end

      local vault_path = vim.env.NOTES_DIR:gsub("/$", "") .. "/"
      local daily_path = vault_path .. "daily/"
      vim.fn.mkdir(daily_path, "p")
      vim.cmd("edit " .. daily_path .. date .. ".md")

      -- Insert date header if file is new
      if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
        local timestamp = os.time({
          year = tonumber(date:sub(1, 4)),
          month = tonumber(date:sub(6, 7)),
          day = tonumber(date:sub(9, 10)),
        })
        local formatted_date = os.date("%A, %B %d, %Y", timestamp)
        vim.api.nvim_buf_set_lines(0, 0, 0, false, { "# " .. formatted_date, "", "" })
        vim.cmd("normal! G")
      end
    end, {
      nargs = "?",
      complete = function()
        return { "today", "tomorrow", "yesterday" }
      end,
      desc = "Open daily note",
    })
  end,
}
