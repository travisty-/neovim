return {
  {
    "stevearc/overseer.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>oo", false },
      { "<leader>ot", false },
      { "<leader>ow", false },
      { "<leader>ta", "<cmd>OverseerTaskAction<cr>", desc = "Task Action" },
      { "<leader>tl", "<cmd>OverseerToggle!<cr>",    desc = "Task List" },
      { "<leader>tt", "<cmd>OverseerRun<cr>",        desc = "Run Task" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>t", group = "overseer", icon = { icon = "\u{ea70}", color = "red" } },
      },
    },
  },
}
