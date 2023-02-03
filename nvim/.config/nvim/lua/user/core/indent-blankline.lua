local M = {}

local blankline_opts = {
  -- for example, context is off by default, use this to turn it on
  show_current_context = false,
  show_current_context_start = false,
}

M.setup = function() 
  local blankline_ok, blankline = pcall(require, "indent_blankline")
  blankline.setup(blankline_opts)
end

return M
