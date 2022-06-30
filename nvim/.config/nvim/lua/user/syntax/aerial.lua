local M = {}
local Log = require"user.log"

local aerial_ok, aerial = pcall(require, "aerial")

M.setup = function ()
  if not aerial_ok then
    Log:info("Aerial not installed")
    return
  end

  aerial.setup({
    backends={ "lsp" },
  })
end

M.on_attach = (aerial_ok and aerial.on_attach) or nil

return M
