local M = {}

-- File types persistence.nvim treats as transient (should not be persisted).
local transient_filetypes = { "gitcommit", "gitrebase", "jj" }

-- A real, *listed* file buffer (i.e. one captured by `mksession`).
-- Must be listed since `:bd` unlists a buffer but holds onto it.
local function is_saveable_buffer(buf)
  return vim.bo[buf].buflisted
    and vim.bo[buf].buftype == ""
    and vim.api.nvim_buf_get_name(buf) ~= ""
    and not vim.tbl_contains(transient_filetypes, vim.bo[buf].filetype)
end

local function any_saveable_buffer()
  return vim.iter(vim.api.nvim_list_bufs()):any(is_saveable_buffer)
end

-- Only save sessions that contain real file buffers. Prevents a fileless session from overwriting
-- a good one, and tmux-resurrect restoring it with empty scratch buffers (e.g. Snacks dashboard).
-- Supports "quit without saving" via `active()`, and is ordered to short-circuit before `require()`.
local function save_session()
  if any_saveable_buffer() and require("persistence").active() then
    require("persistence").save()
  end
end

function M.setup()
  local desc = "Save the session on %s (for tmux-resurrect with persistence.nvim)"
  local group = vim.api.nvim_create_augroup("config.persistence.override", { clear = true })

  -- Persistence.nvim's built-in `VimLeavePre` save hook does not filter to only listed buffers,
  -- which can cause the session to get clobbered on exit with a buffer that was just closed.
  -- Deleting the group directly instead of `stop()` since that breaks "quit without saving".
  LazyVim.on_load("persistence.nvim", function()
    pcall(vim.api.nvim_del_augroup_by_name, "persistence")
  end)

  vim.api.nvim_create_autocmd({ "BufDelete", "BufLeave", "BufWinLeave", "TabLeave", "WinLeave" }, {
    desc = string.format(desc, "layout changes"),
    group = group,
    callback = require("snacks.util").debounce(save_session, { ms = 100 }),
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    desc = string.format(desc, "exit"),
    group = group,
    callback = save_session,
  })
end

return M
