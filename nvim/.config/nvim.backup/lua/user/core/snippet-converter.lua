local M = {}
local utils = require "user.utils"

local snippets_dir = utils.join_paths(get_config_dir(), "snippets")

local template = {
  -- name = "t1", (optionally give your template a name to refer to it in the `ConvertSnippets` command)
  sources = {
    ultisnips = {
      utils.join_paths(snippets_dir, "ultisnips", "tex")
    },
  },
  output = {
    -- Specify the output formats and paths
    vscode_luasnip = {
      --[[ vim.fn.stdpath("config") .. "/luasnip_snippets", ]]
      utils.join_paths(snippets_dir, "ultisnips_converted")
    },
  },
}

function M.setup()
  require("snippet_converter").setup {
    templates = { template }
  }
end

return M
