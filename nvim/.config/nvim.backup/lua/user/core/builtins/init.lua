local M = {}

local builtins = {
  "user.core.terminal",
  "user.core.which-key",
  "user.core.nvimtree",
  "user.core.bufferline",
  "user.core.luasnip",
  "user.core.cmp",
  "user.core.telescope",
  "user.core.gitsigns",
  "user.core.lualine",
  "user.core.project",
  "user.core.alpha",
}

function M.config()
  for _, builtin_path in ipairs(builtins) do
    local builtin = require(builtin_path)
    builtin.config()
  end
end

return M
