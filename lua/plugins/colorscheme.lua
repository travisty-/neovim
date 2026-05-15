return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = 1
      vim.g.everforest_diagnostic_virtual_text = "colored"
      vim.g.everforest_dim_inactive_windows = 1
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_float_style = "dim"
      vim.g.everforest_show_eob = 0
      vim.g.everforest_transparent_background = 2
      vim.cmd([[colorscheme everforest]])
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    config = function()
      require("rose-pine").setup({
        styles = {
          bold = true,
          italic = true,
          transparency = true,
        },
      })
    end,
  },
}
