local M = {}

-- Mirrors the file types persistence.nvim's save filter treats as transient.
local transient_filetypes = { "gitcommit", "gitrebase", "jj" }

local function is_file_buffer(buf)
  return vim.bo[buf].buftype == ""
    and vim.api.nvim_buf_get_name(buf) ~= ""
    and not vim.tbl_contains(transient_filetypes, vim.bo[buf].filetype)
end

local function is_open_file_buffer(buf)
  return vim.bo[buf].buflisted and is_file_buffer(buf)
end

local function first_open_file_buffer()
  return vim.iter(vim.api.nvim_list_bufs()):find(is_open_file_buffer)
end

local function any_file_buffer()
  return vim.iter(vim.api.nvim_list_bufs()):any(is_file_buffer)
end

local function save_session()
  local buf = first_open_file_buffer()

  -- Avoid overwriting the session when no files were ever opened, or during "quit without saving".
  -- Scanning for any file buffers before `require()` avoids loading the plugin unless needed.
  if not (buf or any_file_buffer()) or not require("persistence").active() then
    return
  end

  -- If all files were closed before exiting, we write an empty session file so that the next
  -- launch starts fresh. Calling `save()` here would record an empty layout (arglist, windows),
  -- which get restored as [No Name] windows on startup.
  if not buf then
    vim.fn.writefile({}, require("persistence").current())
    return
  end

  -- `mksession` records blank windows for unnamed buffers (e.g. the Snacks dashboard), which get
  -- restored as [No Name] windows on startup. So we point the window at a real file buffer first.
  if vim.api.nvim_buf_get_name(0) == "" then
    vim.api.nvim_win_set_buf(0, buf)
  end

  require("persistence").save()
end

function M.setup()
  local group = vim.api.nvim_create_augroup("config.persistence.override", { clear = true })

  -- Replace persistence.nvim's built-in save hook: its internal filter includes unlisted buffers,
  -- so a freshly-closed buffer still matches and clobbers the session on exit. Deleting the augroup
  -- rather than calling `stop()` keeps "quit without saving" working.
  LazyVim.on_load("persistence.nvim", function()
    pcall(vim.api.nvim_del_augroup_by_name, "persistence")
  end)

  -- `VimLeavePre` is triggered on SIGTERM/SIGHUP, so saving only on exit still captures the
  -- current files for tmux-resurrect. Unexpected crashes fall back to the previous session.
  vim.api.nvim_create_autocmd("VimLeavePre", {
    desc = "Save the session on exit (for tmux-resurrect with persistence.nvim)",
    group = group,
    callback = save_session,
  })
end

return M
