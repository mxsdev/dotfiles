-- Not sure if nvim_set_hl has the option to retain bg/fg colors?
-- vim.api.nvim_set_hl(0, "Search", { fg="fg", bg="bg", italic=true, underline=true, bold=true })
vim.cmd("hi Search guibg=guibg guifg=guifg gui=italic,underline,bold")

-- For getting highlight group under cursor
vim.api.nvim_create_user_command("HGUnderCursor", function ()
  local res = vim.api.nvim_exec(
  [[
  function! SynStack()
    if !exists("*synstack")
      return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  endfunc

  call SynStack()
  ]],
  true)

  print(res)
end, {})
