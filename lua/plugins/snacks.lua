return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = [[
          ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗          Z
          ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║      Z    
          ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║   z       
          ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ z         
          ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║           
          ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝           
                  未来を変えるのは、いつだって自分だ。                 
        ]],
      },
    },
    picker = {
      hidden = true,
      ignored = true,
      exclude = { ".git" },
    },
    terminal = {
      -- Prevent DCS/passthrough wrapping of ANSI OSC-52 escape sequences.
      -- Otherwise, text copied to the clipboard is leaked into the buffer.
      shell = { "env", "TMUX=", vim.o.shell },
      win = {
        border = "rounded",
        position = "float",
      },
    },
  },
}
