return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
  {
    "neanias/everforest-nvim",
    main = "everforest",
    lazy = true,
    opts = {
      background = "hard",
      float_style = "blend",
      italics = true,
      show_eob = false,
      transparent_background_level = 2,
      ui_contrast = "high",
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      styles = {
        bold = true,
        italic = true,
        transparency = true,
      },
    },
  },
}
