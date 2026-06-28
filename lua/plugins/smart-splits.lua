return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false, -- @pane-is-vim
    opts = {
      at_edge = "stop",
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>W", group = "swap", icon = { icon = "\u{f04e1}", color = "cyan" } },
      },
    },
  },
}
