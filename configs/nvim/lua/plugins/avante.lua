return {
  "yetone/avante.nvim",
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  event = "VeryLazy",
  enabled = false,
  version = false, -- Never set this value to "*"! Never!
  opts = {
    instructions_file = "avante.md",
    provider = "ollama_llama",
    providers = {
      ollama_llama = {
        __inherited_from = "ollama",
        model = "llama3.1:70b",
        endpoint = vim.env.OLLAMA_URL,
        timeout = 90000,
        extra_request_body = {
          options = {
            num_ctx = 8192,
            temperature = 0.1,
          },
        },
      },

    --   -- Qwen 2.5 Coder - Best for coding tasks
    --   ollama_qwen = {
    --     __inherited_from = "ollama",
    --     model = "qwen2.5-coder:14b",
    --     endpoint = vim.env.OLLAMA_URL,
    --     timeout = 60000,
    --     extra_request_body = {
    --       options = {
    --         num_ctx = 24576,
    --         temperature = 0.1,
    --       },
    --     },
    --   },
    --
    --   -- GPT-OSS - Fastest (70tps)
    --   ollama_gpt = {
    --     __inherited_from = "ollama",
    --     model = "gpt-oss:20b",
    --     endpoint = vim.env.OLLAMA_URL,
    --     timeout = 60000,
    --     extra_request_body = {
    --       options = {
    --         num_ctx = 24576, -- Conservative for 20B
    --         temperature = 0.1,
    --       },
    --     },
    --   },
    --
    --   -- Gemma 3 - General purpose (35tps)
    --   ollama_gemma = {
    --     __inherited_from = "ollama",
    --     model = "gemma3:12b",
    --     endpoint = vim.env.OLLAMA_URL,
    --     timeout = 60000,
    --     extra_request_body = {
    --       options = {
    --         num_ctx = 16384,
    --         temperature = 0.1,
    --       },
    --     },
    --   },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-mini/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "stevearc/dressing.nvim", -- for input provider dressing
    "folke/snacks.nvim", -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
