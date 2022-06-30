local M = {}

local Log = require "user.log"
local formatters = require "user.lsp.null-ls.formatters"
local linters = require "user.lsp.null-ls.linters"

function M.setup()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    Log:error "Missing null-ls dependency"
    return
  end

  local default_opts = require("user.lsp").get_common_opts()
  null_ls.setup(vim.tbl_deep_extend("force", default_opts, userconf.lsp.null_ls.setup))

  formatters.setup({
    { name = "prettier" }
  })

  linters.setup({
    {
      name = "eslint"
    }
  })
end

return M
