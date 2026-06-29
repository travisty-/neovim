return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gvo", "<cmd>DiffviewOpen<cr>", desc = "Open" },
      { "<leader>gvc", "<cmd>DiffviewClose<cr>", desc = "Close" },
      { "<leader>gvh", "<cmd>DiffviewFileHistory --follow %<cr>", desc = "File History" },
      { "<leader>gvH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo History" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>gv", group = "diffview", icon = { icon = "\u{f0993}", color = "red" } },
      },
    },
  },
}
