-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_user_command("ShowRootHighlightUnderCursor", function()
  local result = vim.treesitter.get_captures_at_cursor(0)
  print(vim.inspect(result))
end, {})

local function override_everforest_colors()
  vim.cmd("highlight IndentBlanklineChar guifg=#414846")

  -- local red = vim.api.nvim_get_hl(0, { name = "Red" })

  vim.cmd([[ hi link FzfLuaHeaderText Red ]])

  local terminal_black = vim.g.terminal_color_0
  local terminal_white = vim.g.terminal_color_15

  vim.g.terminal_color_0 = terminal_white
  vim.g.terminal_color_8 = terminal_white

  vim.g.terminal_color_7 = terminal_black
  vim.g.terminal_color_15 = terminal_black

  vim.cmd([[hi CurrentWord gui=none guibg=#414846 ]])

  vim.cmd([[hi clear YankyYanked]])
  vim.cmd([[hi YankyYanked gui=underline ]])

  vim.cmd([[hi clear YankyPut]])
  vim.cmd([[hi YankyPut gui=underline ]])

  for _, hl_name in pairs({
    "@keyword",
    "@keyword.import",
    "@function",
    "@function.call",
    -- "@lsp.type.method",
    "@variable.builtin",
    "@keyword.function",
    "@keyword.modifier",
  }) do
    local keyword = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
    vim.api.nvim_set_hl(0, hl_name, {
      fg = keyword.fg,
      bold = true,
    })
  end

  for _, hl_name in pairs({
    "DiagnosticUnderlineError",
    "DiagnosticUnderlineWarn",
    "DiagnosticUnderlineInfo",
    "DiagnosticUnderlineHint",
  }) do
    vim.cmd([[ hi ]] .. hl_name .. [[ guifg=none ]])
  end

  -- vim.cmd([[hi @function.call gui=bold]])
  -- vim.cmd([[hi @lsp.type.method gui=bold]])
  -- -- vim.cmd([[hi @function gui=bold]])
  -- -- vim.cmd([[hi @keyword gui=bold]])
  -- vim.cmd([[hi @lsp.type.selfTypeKeyword.rust gui=bold]])
end

if vim.g.colors_name == "everforest" then
  override_everforest_colors()
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "everforest",
  group = vim.api.nvim_create_augroup("custom_highlight", { clear = true }),
  callback = function()
    override_everforest_colors()
  end,
})
