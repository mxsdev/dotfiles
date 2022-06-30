local Log = require"user.log"

local is_ok, transparent = pcall(require, "transparent")
if not is_ok then 
  Log:warn("Could not load transparent!")
  return
end

require("transparent").setup({
  enable = userconf.transparent_window
})
