local M = {}
local paths = require"user.config.paths"

M.setup = function ()
  vim.cmd("source " .. join_paths(paths.get_plugin_path("vim-markdown-toc"), 'ftplugin', 'markdown.vim'))
end

return M
