local colorscheme = vim.g.colors_name

if colorscheme == "monokaipro" then
  vim.cmd 'hi! link rainbowcol1 jsBraces'
  vim.cmd 'hi! link rainbowcol5 String'
  vim.cmd 'hi! link rainbowcol2 Constant'
  vim.cmd 'hi! link rainbowcol4 Function'
  vim.cmd 'hi! link rainbowcol6 Identifier'
  vim.cmd 'hi! link rainbowcol7 Operator'
  vim.cmd 'hi! link rainbowcol3 Directory'

  -- vim.cmd'hi! link NvimTreeFolderIcon Directory'
end
