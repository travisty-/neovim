return {
  "coder/claudecode.nvim",
  opts = {
    terminal = {
      split_width_percentage = 0.45,
    },
  },
  keys = {
    { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file", ft = { "snacks_picker_list" } },
  },
}
