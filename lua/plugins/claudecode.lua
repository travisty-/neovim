return {
  "coder/claudecode.nvim",
  opts = {
    env = {
      -- Prevent DCS/passthrough wrapping of ANSI OSC-52 escape sequences.
      -- Otherwise, text copied to the clipboard is leaked into the buffer.
      TMUX = "",
    },
    terminal = {
      split_width_percentage = 0.45,
    },
  },
}
