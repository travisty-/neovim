return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      { "<leader>gv", "<cmd>CodeDiff<cr>", desc = "Git Diff (view)" },
    },
    opts = {
      keymaps = {
        view = {
          stage_hunk = "<leader>ghs",
          unstage_hunk = "<leader>ghu",
          discard_hunk = "<leader>ghr",
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>gv", icon = { icon = "\u{f0993}", color = "red" } },
      },
    },
  },
}
