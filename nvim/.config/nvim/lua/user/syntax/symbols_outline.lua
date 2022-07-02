local M = {}

M.setup = function ()
  vim.g.symbols_outline = {
    auto_preview = false,
    autofold_depth = 1,
    auto_unfold_hover = true,
    only_reload_on_change = true,
    show_numbers = true,
    show_relative_numbers = true,
  }
end

return M
