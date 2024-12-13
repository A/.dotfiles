local mode = { "n", "x" }

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
    "nvim-telescope/telescope.nvim",
    "echasnovski/mini.nvim",
  },
  config = function()
    require("codecompanion").setup({
      display = {
        diff = {
          provider = "mini_diff",
        },
        action_palette = {
          provider = "telescope",
        },
      },
      adapters = {
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            env = {
              api_key = os.getenv("OPENAI_API_KEY"),
            },
          })
        end,
      },

      strategies = {
        chat = {
          adapter = "openai",
        },
        inline = {
          adapter = "openai",
        },
      },
      prompt_library = {
        ["Review"] = {
          strategy = "chat",
          description = "Review code in a buffer",
          opts = {
            mapping = "<leader>ar",
            modes = { "v" },
            short_name = "review",
            auto_submit = true,
            stop_context_insertion = true,
            user_prompt = false,
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return "I want you to act as a senior "
                  .. context.filetype
                  .. " developer."
                  .. " You need to review the given code and provide concise summary of issues, unoptimal solutions, and possible risks in the code."
                  .. " I will ask you specific questions and I want you to return concise explanations and codeblock examples."
              end,
            },
            {
              role = "user",
              content = function(context)
                local text
                if context.is_visual then
                  text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                else
                  local buf_utils = require("codecompanion.utils.buffers")
                  text = buf_utils.get_content(context.bufnr)
                end

                return "Review the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Optimize"] = {
          strategy = "inline",
          description = "Optimize given code",
          opts = {
            mapping = "<leader>ao",
            short_name = "optimize",
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return "I want you to act as a senior "
                  .. context.filetype
                  .. " developer."
                  .. " I will give code and I want you in response to return a code that can replace this code without any additional explanations or new comments. "
              end,
            },
            {
              role = "user",
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return "Please optimize following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
    })
  end,

  keys = {
    { "<leader>aa", vim.cmd.CodeCompanionActions, mode = mode, desc = "Code Companion Actions" },
    {
      "<leader>ac",
      function()
        vim.cmd.CodeCompanionChat("Toggle")
      end,
      mode = mode,
      desc = "Code Companion Chat",
    },
    {
      "<leader>ad",
      function()
        require("codecompanion").prompt("lsp")
      end,
      mode = mode,
      desc = "Debug Diagnostics",
    },
    {
      "<leader>af",
      function()
        require("codecompanion").prompt("fix")
      end,
      mode = mode,
      desc = "Fix Code",
    },
    {
      "<leader>ao",
      function()
        require("codecompanion").prompt("optimize")
      end,
      mode = mode,
      desc = "Optimize",
    },
    {
      "<leader>ar",
      function()
        require("codecompanion").prompt("review")
      end,
      mode = mode,
      desc = "Review",
    },
  },
}
