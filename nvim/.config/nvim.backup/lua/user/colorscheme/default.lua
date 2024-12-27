local Log = require "user.log"

--[[ vim.g.everforest_background = 'hard' ]]

local colorscheme = userconf.colorscheme

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  Log:warn("Unable to find colorscheme " .. colorscheme .. "!")
  -- vim.notify("colorscheme ")
  return
end

--[[ local status_ok, noirbuddy = pcall(require, "noirbuddy") ]]
--[[ if status_ok then ]]
--[[   require('noirbuddy').setup { ]]
--[[     preset = 'slate', ]]
--[[   } ]]
--[[ end ]]
