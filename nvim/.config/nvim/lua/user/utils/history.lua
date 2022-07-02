local M = {}

function M.open_recent_file()
  local files = vim.v.oldfiles

  if #files == 0 then
    return
  end

  vim.cmd(string.format('e %s', files[1]))
end

return M
