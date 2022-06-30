-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
local M = {}

function M.setup()
  local config = { -- your config
    virtual_text = userconf.lsp.diagnostics.virtual_text,
    signs = userconf.lsp.diagnostics.signs,
    underline = userconf.lsp.diagnostics.underline,
    update_in_insert = userconf.lsp.diagnostics.update_in_insert,
    severity_sort = userconf.lsp.diagnostics.severity_sort,
    float = userconf.lsp.diagnostics.float,
  }
  vim.diagnostic.config(config)
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, userconf.lsp.float)
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, userconf.lsp.float)
end

return M
