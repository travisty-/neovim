-- Keymaps are automatically loaded on the VeryLazy event.
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- Add any additional keymaps here:

local map = vim.keymap.set

map("i", "jj", "<Esc>", { desc = "Exit Insert Mode" })

-- Save the current file without closing it.
map("n", "ZS", "<cmd>update<cr>", { desc = "Save File" })

-- Center the viewport after scrolling up or down.
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down" })
