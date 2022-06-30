local M = {}
local Log = require"user.log"

M.config = function()
  userconf.builtin.luasnip = {
    sources = {
      friendly_snippets = true,
    },
  }
end

M.setup = function()
  local utils = require "user.utils"
  local paths = {}

  if userconf.builtin.luasnip.sources.friendly_snippets then
    paths[#paths + 1] = utils.join_paths(get_runtime_dir(), "site", "pack", "packer", "start", "friendly-snippets")
  end

  local user_snippets = utils.join_paths(get_config_dir(), "snippets")
  if utils.is_directory(user_snippets) then
    paths[#paths + 1] = user_snippets
  end

  require("luasnip.loaders.from_lua").lazy_load()
  require("luasnip.loaders.from_vscode").lazy_load {
    paths = paths,
  }
  require("luasnip.loaders.from_snipmate").lazy_load()
end

return M
