local M = {}
local Log = require "user.log"

M.swapUpMaster = function()
	vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
	return "g@l"
end

M.swapDownMaster = function()
	vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
	return "g@l"
end

M.swapUpCurrent = function()
	vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
	return "g@l"
end

M.swapDownCurrent = function()
	vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
	return "g@l"
end

M.setup = function()
  local tsurfer_ok, tsurfer = pcall(require, "syntax-tree-surfer")
  if not tsurfer_ok then
    Log:warn("Syntax tree surfer not installed")
    return
  end
end

return M
