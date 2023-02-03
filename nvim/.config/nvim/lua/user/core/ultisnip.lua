local M = {}
local utils = require "user.utils"

function M.setup()
  vim.g.UltiSnipsSnippetDirectories = {
    utils.join_paths(get_config_dir(), "snippets", "ultisnips")
  }
end

return M
