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
-- window otherwise (e.g. the nameless window that's automatically created
-- when you close the last buffer via the Snacks buffer picker).
local function find_eligible_window()
  local current = vim.api.nvim_get_current_win()
  if is_eligible_window(current) then
    return current
  end
  return vim.iter(vim.api.nvim_tabpage_list_wins(0)):find(is_eligible_window)
end

local function open_dashboard(win, buf)
  if Snacks and Snacks.dashboard then
    Snacks.dashboard({ win = win, buf = buf }) ---@diagnostic disable-line: missing-fields
  end
end

-- Closes the Snacks buffer picker when focused. This is a UX workaround to avoid
-- rendering the Snacks dashboard in the preview pane after closing the last buffer.
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
          open_dashboard(win, vim.api.nvim_win_get_buf(win))
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
