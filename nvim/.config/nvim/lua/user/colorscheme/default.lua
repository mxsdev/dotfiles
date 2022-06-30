local Log = require "user.log"

local colorscheme = userconf.colorscheme

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  Log:warn("Unable to find colorscheme " .. colorscheme .. "!")
  -- vim.notify("colorscheme ")
  return
end
