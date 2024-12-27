local M = {}
local utils = require"user.utils"

function M.get_recent_files(cwd_only)
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buffer)
  local results = {}

  if true then
    for _, buffer in ipairs(vim.split(vim.fn.execute ":buffers! t", "\n")) do
      local match = tonumber(string.match(buffer, "%s*(%d+)"))
      local open_by_lsp = string.match(buffer, "line 0$")
      if match and not open_by_lsp then
        local file = vim.api.nvim_buf_get_name(match)
        if vim.loop.fs_stat(file) and match ~= current_buffer then
          table.insert(results, file)
        end
      end
    end
  end

  for _, file in ipairs(vim.v.oldfiles) do
    if vim.loop.fs_stat(file) and not vim.tbl_contains(results, file) and file ~= current_file then
      table.insert(results, file)
    end
  end

  if cwd_only then
    local cwd = vim.loop.cwd()
    cwd = cwd:gsub([[\]], [[\\]])
    results = vim.tbl_filter(function(file)
      return vim.fn.matchstrpos(file, cwd)[2] ~= -1
    end, results)
  end

  return results
end

function M.open_recent_file(cwd_only)
  local results = M.get_recent_files(cwd_only or false)

  if #results == 0 then
    return
  end

  utils.edit(results[1])
end

return M
