-- Autocmds are automatically loaded on the VeryLazy event.
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here with `vim.api.nvim_create_autocmd`:
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults).
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Reopen the Snacks dashboard after closing the last buffer.
require("config.dashboard").setup()

-- Automatically change directories.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("config.autocmds.cd", { clear = true }),
  callback = function()
    if vim.fn.argc() == 1 then
      local arg = vim.fn.argv(0) --[[@as string]]
      if vim.fn.isdirectory(arg) == 1 then
        vim.schedule(function()
          vim.cmd.cd(vim.fn.fnameescape(arg))
        end)
      end
    end
  end,
})

-- Save session state on layout changes (for tmux-resurrect)
vim.api.nvim_create_autocmd({ "BufDelete", "BufLeave", "BufWinLeave", "TabLeave", "WinLeave" }, {
  group = vim.api.nvim_create_augroup("config.autocmds.persistence", { clear = true }),
  callback = require("snacks.util").debounce(function()
    require("persistence").save()
  end, { ms = 100 }),
})
