-- Keymaps are automatically loaded on the VeryLazy event.
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- Add any additional keymaps here:

local map = vim.keymap.set

map("i", "jj", "<Esc>", { desc = "Exit Insert Mode" })

-- Move macro recording to Q to avoid accidental key presses.
-- The default replay behavior of Q is still accessible via @@.
map("n", "Q", "q", { desc = "Record Macro" })
map("n", "q", "<Nop>")

-- Save the current file without closing it.
map("n", "ZS", "<cmd>update<cr>", { desc = "Save File" })

-- Center the viewport after scrolling up or down.
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down" })

-- Exit terminal mode (when in terminals launched with :terminal).
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })

---@source ../plugins/smart-splits.lua

local ss = require("smart-splits")

-- Navigate between splits and panes.
map("n", "<C-h>", ss.move_cursor_left, { desc = "Go to Left Split/Pane" })
map("n", "<C-j>", ss.move_cursor_down, { desc = "Go to Lower Split/Pane" })
map("n", "<C-k>", ss.move_cursor_up, { desc = "Go to Upper Split/Pane" })
map("n", "<C-l>", ss.move_cursor_right, { desc = "Go to Right Split/Pane" })

-- Resize splits and panes.
map("n", "<C-Up>", ss.resize_up, { desc = "Resize Split Up" })
map("n", "<C-Down>", ss.resize_down, { desc = "Resize Split Down" })
map("n", "<C-Left>", ss.resize_left, { desc = "Resize Split Left" })
map("n", "<C-Right>", ss.resize_right, { desc = "Resize Split Right" })

-- Swap buffers with the window in the specified direction.
map("n", "<leader>Wh", ss.swap_buf_left, { desc = "Swap Buffer Left" })
map("n", "<leader>Wj", ss.swap_buf_down, { desc = "Swap Buffer Down" })
map("n", "<leader>Wk", ss.swap_buf_up, { desc = "Swap Buffer Up" })
map("n", "<leader>Wl", ss.swap_buf_right, { desc = "Swap Buffer Right" })

-- Restore the default readline key binding for clearing the screen (`<C-l>`).
-- `<C-l>` is also used for navigation in nvim/tmux, so we relay it via `<F48>`.
map("t", "<F48>", "<C-l>", { desc = "Clear Terminal" })
