local M = {}

local function is_exiting()
  return vim.v.exiting ~= vim.NIL
end

local function is_normal_buffer(buf)
  return vim.bo[buf].buflisted and vim.bo[buf].buftype == ""
end

local function is_occupied_buffer(buf)
  return is_normal_buffer(buf) and (vim.api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].modified)
end

local function is_unoccupied_buffer(buf)
  return is_normal_buffer(buf) and vim.api.nvim_buf_get_name(buf) == "" and not vim.bo[buf].modified
end

local function any_occupied_buffer()
  return vim.iter(vim.api.nvim_list_bufs()):any(is_occupied_buffer)
end

local function is_dashboard_buffer(buf)
  return vim.bo[buf].filetype == "snacks_dashboard"
end

-- Scoped to the current tab; a dashboard open in another tab shouldn't prevent
-- us from opening one in this tab if the necessary conditions are met.
local function is_dashboard_open()
  return vim.iter(vim.api.nvim_tabpage_list_wins(0)):any(function(win)
    return is_dashboard_buffer(vim.api.nvim_win_get_buf(win))
  end)
end

local function is_normal_window(win)
  return vim.fn.win_gettype(win) == "" and not vim.w[win].snacks_win
end

local function is_eligible_window(win)
  return is_normal_window(win) and is_unoccupied_buffer(vim.api.nvim_win_get_buf(win))
end

-- Scoped to the current tab; prefers the current window or the first eligible
-- window otherwise (e.g. the window containing default "[No Name]" buffer).
local function find_eligible_window()
  local current = vim.api.nvim_get_current_win()
  if is_eligible_window(current) then
    return current
  end
  return vim.iter(vim.api.nvim_tabpage_list_wins(0)):find(is_eligible_window)
end

-- Discard the default "[No Name]" buffer that Neovim opens to populate an empty window,
-- but only if that buffer has already been replaced by the Snacks dashboard (no window).
-- If the window is special (e.g. Snacks buffer picker), wipe it from the list instead.
local function discard_default_buffer(buf)
  if not (vim.api.nvim_buf_is_valid(buf) and is_unoccupied_buffer(buf)) then
    return
  end
  local wins = vim.fn.win_findbuf(buf)
  if vim.tbl_isempty(wins) then
    vim.api.nvim_buf_delete(buf, { force = true })
  elseif not vim.iter(wins):any(is_normal_window) then
    vim.bo[buf].buflisted = false
    vim.bo[buf].bufhidden = "wipe"
  end
end

-- Open the Snacks dashboard in a buffer it owns, not the default "[No Name]" buffer.
-- Reusing the default buffer can cause the Snacks dashboard to be rendered in multiple
-- windows at once, which triggers a resize error: "Invalid cursor line: out of range".
local function open_dashboard(win)
  if not (Snacks and Snacks.dashboard) then
    return
  end
  local default = vim.api.nvim_win_get_buf(win)
  Snacks.dashboard({ win = win }) ---@diagnostic disable-line: missing-fields
  discard_default_buffer(default)
end

-- Closes the Snacks buffer picker when focused. This ensures that the
-- picker doesn't retain focus after closing the last buffer in its list.
local function close_buffer_picker()
  if not (Snacks and Snacks.picker) then
    return
  end
  for _, picker in ipairs(Snacks.picker.get({ source = "buffers" })) do
    if picker:is_focused() then
      picker:close()
    end
  end
end

local desc = "Reopen the Snacks dashboard after closing the last buffer."
local group = vim.api.nvim_create_augroup("config.dashboard.reopen", { clear = true })

function M.setup()
  vim.api.nvim_create_autocmd("BufDelete", {
    desc = desc,
    group = group,
    callback = function()
      vim.schedule(function()
        if is_exiting() or any_occupied_buffer() or is_dashboard_open() then
          return
        end
        local win = find_eligible_window()
        if win then
          open_dashboard(win)
          close_buffer_picker()
          -- Snacks.picker:close() may refocus the picker's origin window
          -- (which isn't guaranteed to be the window the dashboard is in)
          -- so we manually focus it.
          vim.api.nvim_set_current_win(win)
        end
      end)
    end,
  })
end

return M
