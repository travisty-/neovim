return {
  {
    "stevearc/overseer.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>oo", false },
      { "<leader>ot", false },
      { "<leader>ow", false },
      { "<leader>ta", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
      { "<leader>tl", "<cmd>OverseerToggle!<cr>",    desc = "Task list" },
      { "<leader>tt", "<cmd>OverseerRun<cr>",        desc = "Run task" },
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
