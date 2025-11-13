return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = {
          "require",
          "vim",
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
