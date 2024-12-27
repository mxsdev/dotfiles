local M = {}
local widgets = require"dap.ui.widgets"
local ui = require"dap.ui"

-- stolen from https://github.com/mfussenegger/nvim-dap/blob/master/lua/dap/ui/widgets.lua
-- makes sidebar open function
local function mk_sidebar_win_func(winopts, wincmd)
  return function()
    vim.cmd(wincmd or '30 vsplit')
    local win = vim.api.nvim_get_current_win() 
    vim.api.nvim_win_set_option(win, 'number', false)
    vim.api.nvim_win_set_option(win, 'relativenumber', false)
    vim.api.nvim_win_set_option(win, 'statusline', ' ')
    ui.apply_winopts(win, winopts)
    return win
  end
end

local function build_sidebar_view(widget, winopts, wincmd)
  return widgets.builder(widget)
    -- .keep_focus()
    .new_win(mk_sidebar_win_func(winopts, wincmd))
    .new_buf(widgets.with_refresh(widget.new_buf, widget.refresh_listener or 'event_stopped'))
    .build()
end

local builtins = { "scopes", "frames", "expression", "threads" }

local views = { }

for i, val in ipairs(builtins) do
  views[val] = views[val] or { }
-- (i == 1 and 'right split') or 'below split'
  views[val]['sidebar'] = build_sidebar_view(widgets[val], nil, (i == 1 and '30 vsplit') or 'split')--[[ widgets.sidebar(widgets[val]) ]]
end

M.sidebar = { }
 
for _, builtin in ipairs(builtins) do
  M.sidebar[builtin] = function (winopts, wincmd)
    local view = views[builtin].sidebar

    view.toggle()

    return view
  end
end

M.sidebar.all = function ()
  local start_win = vim.api.nvim_get_current_win()
  local first_win = nil

  for i, builtin in ipairs(builtins) do
    local view = views[builtin].sidebar

    if i == 1 then
      first_win = view.toggle()

      if first_win then
        vim.api.nvim_set_current_win(first_win.win)
      end
    else
      view.toggle()
    end

    -- if view.buf then
    --  vim.api.nvim_buf_set_lines(view.buf, 0, -1, false, { }) 
    -- end
  end

  vim.api.nvim_set_current_win(start_win)
end

return M
