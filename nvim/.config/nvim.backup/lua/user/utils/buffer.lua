local M = {} 

function M.setup()
  
end

function M.buffer_width()
  local w = vim.api.nvim_exec([[
let width = winwidth(0)
let numberwidth = max([&numberwidth, strlen(line('$')) + 1])
let numwidth = (&number || &relativenumber) ? numberwidth : 0
let foldwidth = &foldcolumn

if &signcolumn == 'yes'
    let signwidth = 2
elseif &signcolumn =~ 'yes'
    let signwidth = &signcolumn
    let signwidth = split(signwidth, ':')[1]
    let signwidth *= 2  " each signcolumn is 2-char wide
elseif &signcolumn == 'auto'
    let supports_sign_groups = has('nvim-0.4.2') || has('patch-8.1.614')
    let signlist = execute(printf('sign place ' . (supports_sign_groups ? 'group=* ' : '') . 'buffer=%d', bufnr('')))
    let signlist = split(signlist, "\n")
    let signwidth = len(signlist) > 2 ? 2 : 0
elseif &signcolumn =~ 'auto'
    let signwidth = 0
    if len(sign_getplaced(bufnr(),{'group':'*'})[0].signs)
        let signwidth = 0
        for l:sign in sign_getplaced(bufnr(),{'group':'*'})[0].signs
            let lnum = l:sign.lnum
            let signs = len(sign_getplaced(bufnr(),{'group':'*', 'lnum':lnum})[0].signs)
            let signwidth = (signs > signwidth ? signs : signwidth)
        endfor
    endif
    let signwidth *= 2   " each signcolumn is 2-char wide
else
    let signwidth = 0
endif

 
  ]], true)

  local res = vim.api.nvim_eval("width - numwidth - foldwidth - signwidth")

  print(res)

  -- return vim.api.nvim_eval("call g:BufferWidth()")
end

function M.buffer_max_line(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  return math.max(unpack(vim.tbl_map(function(el)
    return #el
  end, lines)))
end

return M
