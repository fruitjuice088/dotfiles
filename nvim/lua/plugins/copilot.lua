if not vim.env.OneDriveCommercial then
  return {}
end

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
      },
      panel = { enabled = false },
      filetypes = {
        yaml = true,
        markdown = true,
        help = true,
        gitcommit = true,
        gitrebase = true,
        hgcommit = true,
      },
    },
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
        require("CopilotChat").setup({
          show_help = "yes",
          prompts = {
            Explain = {
              prompt = "/COPILOT_EXPLAIN コードを日本語で説明してください",
              mapping = "<leader>ce",
              description = "コードの説明をお願いする",
            },
            Review = {
              prompt = "/COPILOT_REVIEW コードを日本語でレビューしてください。",
              mapping = "<leader>cr",
              description = "コードのレビューをお願いする",
            },
            Fix = {
              prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードを表示してください。説明は日本語でお願いします。",
              mapping = "<leader>cf",
              description = "コードの修正をお願いする",
            },
            Optimize = {
              prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。説明は日本語でお願いします。",
              mapping = "<leader>co",
              description = "コードの最適化をお願いする",
            },
            Docs = {
              prompt = "/COPILOT_GENERATE 選択したコードに関するドキュメントコメントを日本語で生成してください。",
              mapping = "<leader>cd",
              description = "コードのドキュメント作成をお願いする",
            },
            Tests = {
              prompt = "/COPILOT_TESTS 選択したコードの詳細なユニットテストを書いてください。説明は日本語でお願いします。",
              mapping = "<leader>ct",
              description = "テストコード作成をお願いする",
            },
            FixDiagnostic = {
              prompt = "コードの診断結果に従って問題を修正してください。修正内容の説明は日本語でお願いします。",
              mapping = "<leader>cd",
              description = "コードの修正をお願いする",
              selection = require("CopilotChat.select").diagnostics,
            },
            Commit = {
              prompt = "実装差分に対するコミットメッセージを日本語で記述してください。",
              mapping = "<leader>cco",
              description = "コミットメッセージの作成をお願いする",
              selection = require("CopilotChat.select").gitdiff,
            },
            CommitStaged = {
              prompt = "ステージ済みの変更に対するコミットメッセージを日本語で記述してください。",
              mapping = "<leader>cs",
              description = "ステージ済みのコミットメッセージの作成をお願いする",
              selection = function(source)
                return require("CopilotChat.select").gitdiff(source, true)
              end,
            },
          },
        }),
      }
    end,
    keys = {
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          vim.ui.input({
            prompt = "Quick Chat: ",
          }, function(input)
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end)
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "v" },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },
}
