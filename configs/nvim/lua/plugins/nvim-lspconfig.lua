return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },

  dependencies = {
    "williamboman/mason.nvim",
    { "williamboman/mason-lspconfig.nvim", config = function() end },
    { "nvim-lua/lsp-status.nvim" },
    { "arkav/lualine-lsp-progress" },
    { "SmiteshP/nvim-navic" },
  },

  config = function()
    local navic = require("nvim-navic")
    navic.setup({
      icons = {
        File = "󰈙 ",
        Module = " ",
        Namespace = "󰌗 ",
        Package = " ",
        Class = "󰌗 ",
        Method = "󰆧 ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = "󰕘",
        Interface = "󰕘",
        Function = "󰊕 ",
        Variable = "󰆧 ",
        Constant = "󰏿 ",
        String = "󰀬 ",
        Number = "󰎠 ",
        Boolean = "◩ ",
        Array = "󰅪 ",
        Object = "󰅩 ",
        Key = "󰌋 ",
        Null = "󰟢 ",
        EnumMember = " ",
        Struct = "󰌗 ",
        Event = " ",
        Operator = "󰆕 ",
        TypeParameter = "󰊄 ",
      },
      lsp = {
        auto_attach = true,
        preference = nil,
      },
      highlight = true,
      separator = " > ",
      depth_limit = 0,
      depth_limit_indicator = "..",
      safe_output = true,
      lazy_update_context = false,
      click = false,
      format_text = function(text)
        return text
      end,
    })

    local util = require("lspconfig/util")

    local enabled_servers = { "pyright", "ts_ls", "ansiblels", "rust_analyzer", "yamlls", "efm" }

    local settings = {
      pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
            },
          },
        },
        root_dir = function(fname)
          local root_files = {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            "pyrightconfig.json",
          }
          return util.root_pattern(unpack(root_files))(fname)
            or util.find_git_ancestor(fname)
            or util.path.dirname(fname)
        end,
      },
      ts_ls = {},
      efm = {
        settings = {
          rootMarkers = { ".eslintrc.json", "package.json", ".git" },
          languages = {
            javascript = {
              {
                lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
                lintStdin = true,
                lintFormats = { "%f:%l:%c: %m" },
                lintIgnoreExitCode = true,
              }
            },
            javascriptreact = {
              {
                lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
                lintStdin = true,
                lintFormats = { "%f:%l:%c: %m" },
                lintIgnoreExitCode = true,
              }
            },
            typescript = {
              {
                lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
                lintStdin = true,
                lintFormats = { "%f:%l:%c: %m" },
                lintIgnoreExitCode = true,
              }
            },
            typescriptreact = {
              {
                lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
                lintStdin = true,
                lintFormats = { "%f:%l:%c: %m" },
                lintIgnoreExitCode = true,
              }
            },
          }
        }
      }
    }

    -- nvim-cmp supports additional completion capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
      automatic_enable = true,
      ensure_installed = enabled_servers,
    })

    -- mason_lspconfig.setup_handlers({
    --   function(server_name)
    --     require("lspconfig")[server_name].setup({
    --       capabilities = capabilities,
    --       settings = (settings[server_name] or {}).settings,
    --       filetypes = (settings[server_name] or {}).filetypes,
    --       root_dir = (settings[server_name] or {}).root_dir,
    --       on_attach = function(client, bufnr)
    --         if client.server_capabilities.documentSymbolProvider then
    --           require("nvim-navic").attach(client, bufnr)
    --         end
    --       end,
    --     })
    --   end,
    -- })

    require("lsp-status").config({
      indicator_errors = "E:",
      indicator_warnings = "W:",
      indicator_info = "I:",
      indicator_hint = "H:",
      indicator_ok = "Ok",
      current_function = false,
      show_filename = false,
    })
  end,
}
