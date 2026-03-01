return {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        allTargets = false,
      },
      check = {
        command = "clippy",
        extraArgs = { "--no-deps" },
      },
      procMacro = {
        enable = true,
      },
    },
  },
}
