return {
  "coder/claudecode.nvim",
  opts = {
    env = {
      -- Prevent DCS/passthrough wrapping of ANSI OSC-52 escape sequences.
      -- Otherwise, text copied to the clipboard is leaked into the buffer.
      TMUX = "",
    },
    terminal = {
      provider = "snacks",
      snacks_win_opts = {
        height = 0.9,
        position = "float",
        width = 0.9,
      },
    },
  },
  keys = {
    { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file", ft = { "snacks_picker_list" } },
  },
}
