local M = {}

local data_dir = vim.fn.stdpath "data"

M.get_plugin_path = function(plugin)
  return join_paths(data_dir, 'site', 'pack', 'packer', 'start', plugin )
end

return M
