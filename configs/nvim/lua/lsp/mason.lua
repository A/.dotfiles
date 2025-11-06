return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "ansiblels",
        "ts_ls",
        "basedpyright",
        "cssls",
        "cssmodules_ls",
        "docker_language_server",
        "efm",
        -- "emmet_ls",
        "gh_actions_ls",
        "helm_ls",
        "html",
        "lua_ls",
        "markdown_oxide",
      },
    },
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
}
