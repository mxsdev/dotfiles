local M = {} 

M.setup = function ()
  vim.api.nvim_exec([[let g:VM_maps = {}]], false)

  vim.api.nvim_exec([[let g:VM_maps["Exit"] = '<C-c>']], false)
end

return M
