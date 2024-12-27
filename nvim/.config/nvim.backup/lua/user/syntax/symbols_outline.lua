local M = {}

M.setup = function ()
  local status_ok, outline = pcall(require, "symbols-outline")

  if status_ok then
    outline.setup({
      auto_preview = false,
      autofold_depth = 1,
      auto_unfold_hover = true,
      show_numbers = true,
      show_relative_numbers = true,
      --[[ fold_markers = false, ]]
    })
  end

  -- vim.g.symbols_outline = 
end

return M
