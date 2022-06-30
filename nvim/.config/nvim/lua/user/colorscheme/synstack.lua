local M = {}

M.SynStack = function ()
  return vim.cmd([[if exists("*synstack")
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  endif]])
end

return M
