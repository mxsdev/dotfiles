local colorscheme = userconf.colorscheme

-- Everforest
if colorscheme == 'everforest' then
  -- for indent: blend between 2b2b2b and #56635f
  vim.cmd 'highlight IndentBlanklineChar guifg=#414846'
end

-- Bold highlight groups

--[[ local bold_groups = { ]]
--[[   'Keyword', ]]
--[[   '@namespace', ]]
--[[   '@function', ]]
--[[   '@function.call', ]]
--[[   '@type.qualifier', ]]
--[[   '@keyword', ]]
--[[ } ]]
--[[]]
--[[ for _, group in ipairs(bold_groups) do ]]
  --[[ vim.cmd 'hi! Keyword gui=bold cterm=bold' ]]
--[[   vim.cmd(string.format("hi! %s gui=bold cterm=bold", group)) ]]
--[[ end ]]
--[[]]
--[[ local unbold_groups = { ]]
--[[   '@variable' ]]
--[[ } ]]
--[[]]
--[[ for _, group in ipairs(unbold_groups) do ]]
--[[   vim.cmd(string.format("hi! %s gui=NONE cterm=NONE", group)) ]]
--[[ end ]]
