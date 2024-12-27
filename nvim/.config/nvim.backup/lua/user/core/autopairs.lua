local Log = require "user.log"

local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
  Log:warn("Unable to load nvim-autopairs")
  return
end

npairs.setup {
  check_ts = true,
  -- ts_config = {
  --   lua = { "string", "source" },
  --   javascript = { "string", "template_string" },
  --   java = false,
  -- },
  enable_bracket_in_quote = false,
  -- enable_check_bracket_line = false,
  disable_filetype = { "TelescopePrompt", "spectre_panel" },
  -- fast_wrap = {
  --   map = "<M-e>",
  --   chars = { "{", "[", "(", '"', "'", "`" },
  --   pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
  --   offset = 0, -- Offset from pattern match
  --   end_key = "$",
  --   keys = "qwertyuiopzxcvbnmasdfghjkl",
  --   check_comma = true,
  --   highlight = "PmenuSel",
  --   highlight_grey = "LineNr",
  -- },
  -- map_cr = false
}

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  Log:warn("Unable to load cmp")
  return
end

local cmp_autopairs = require "nvim-autopairs.completion.cmp"
local cmp_autopairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if not cmp_autopairs_ok then
  Log:warn("Unable to load nvim autopairs cmp")
  return
end

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
