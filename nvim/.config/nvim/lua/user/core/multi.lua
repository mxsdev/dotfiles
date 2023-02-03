local M = {} 

M.setup = function ()
  vim.api.nvim_exec([[let g:VM_maps = {}]], false)

  vim.api.nvim_exec([[let g:VM_maps["Exit"] = '<C-c>']], false)
  vim.api.nvim_exec([[let g:VM_maps["Add Cursor Down"] = '<C-j>']], false)
  vim.api.nvim_exec([[let g:VM_maps["Add Cursor Up"] = '<C-k>']], false)
end

return M
