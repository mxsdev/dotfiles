local M = {}
local Log = require"user.log"

M.setup = function ()
  local autotag_ok, autotag = pcall(require, "nvim-ts-autotag")
  if not autotag_ok then
    Log:warn("Autotag not installed!")
    return
  end
  autotag.setup({

  })
end

return M
