-- Not sure if nvim_set_hl has the option to retain bg/fg colors?
-- vim.api.nvim_set_hl(0, "Search", { fg="fg", bg="bg", italic=true, underline=true, bold=true })
vim.cmd("hi Search guibg=guibg guifg=guifg gui=italic,underline,bold")
