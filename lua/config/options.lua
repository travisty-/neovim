-- Options are automatically loaded before lazy.nvim startup.
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
--
-- Add any additional options here:

-- stylua: ignore
-- Patch the default cursor styles for each mode.
vim.o.guicursor = vim.o.guicursor
  :gsub("i%-ci%-ve:ver25", "%0-blinkon500-blinkoff500")
  :gsub("t:block", "t:ver25")

-- Disable legacy 'smartindent' rule "When you type # as the first character
-- of a line, the indentation is deleted and the # is forced to column 0."
vim.o.smartindent = false

-- Prevents floating windows from visually blending into the main buffer.
-- Only required when the color scheme's float mode is set to "blend".
vim.o.winborder = "rounded"
