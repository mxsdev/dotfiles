local M = {}

local _, builtin = pcall(require, "telescope.builtin")

-- Smartly opens either git_files or find_files, depending on whether the working directory is
-- contained in a Git repo.
function M.find_project_files()
  local ok = pcall(builtin.git_files, {
    show_untracked=true
  })

  if not ok then
    builtin.find_files()
  end
end

return M
