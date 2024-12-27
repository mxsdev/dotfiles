local M = {}
local utils = require"user.utils"
local ts_utils = require"nvim-treesitter.ts_utils"
local parsers = require"nvim-treesitter.parsers"
local CU = require"Comment.utils"
local CC = require"Comment.config"

local jsx_element = 'jsx_element'
local jsx_closed_element = 'jsx_self_closing_element'

local fix_inner_size = function(buf, inner_range, left, a, b, c, d)
  local text = vim.api.nvim_buf_get_text(buf, a, b, c, d, {})
  local index_shift = (left and 0) or 2
  local range_shift = (left and 1) or -1

  if #text > 1 then
    inner_range[1 + index_shift] = inner_range[1 + index_shift] + range_shift
    inner_range[2 + index_shift] = 0
  end
end

local remove_whitespace_front = function(text, a, b, c, d)
  for _, val in ipairs(text) do
    for i = 1, #val do
      local char = val:sub(i,i)

      if string.find(char, '%s') == nil then
        return a, b
      end

      b = b + 1
    end

    b = 0
    a = a + 1
  end
end

local remove_whitespace_back = function(text, a, b, c, d)
  for j, _ in ipairs(text) do
    local val = text[#text - j + 1]

    for k = 1, #val do
      local char = val:sub(#val - k + 1, #val - k + 1)

      if string.find(char, '%s') == nil then
        return c, d
      end

      d = d - 1
    end

    c = c - 1
    if j < #text then d = #(text[#text - j]) - 1 end
  end
end

M.is_react_node = function(node, buf)
  -- print(node:type() .. ', ' .. tostring(node:named()) .. ', ' .. tostring(node:type() ~= jsx_closed_element) )

  if (not node:named()) or (node:type() ~= jsx_element and node:type() ~= jsx_closed_element) then
    return
  end
  
  local inner_range = nil

  if node:type() == jsx_element then
    local child_count = node:child_count()
    local i = 1

    local first_child = nil
    local last_child = nil

    for child in node:iter_children() do
      if i == 2 then
        first_child = child
      elseif i == child_count - 1 then
        last_child = child
      end
      i = i + 1
    end

    last_child = last_child or first_child

    local a, b, c, d = first_child:range()
    local x, y, z, w = last_child:range()

    local text = vim.api.nvim_buf_get_text(buf, a, b, z, w, {})

    local na, nb = remove_whitespace_front(text, a, b, z, w)
    local nz, nw = remove_whitespace_back(text, a, b, z, w)

    if na and nb and nz and nw then
      inner_range = { na, nb, nz, nw + 1 }
    end

    --[[ if first_child and last_child then
      local a, b, c, d = first_child:range()
      local x, y, z, w = last_child:range()

      inner_range = { a, b, z, w }

      if first_child:type() == 'jsx_text' then
        fix_inner_size(buf, inner_range, true, a, b, c, d)
      elseif last_child:type() == 'jsx_text' then
        fix_inner_size(buf, inner_range, false, x, y, z, w)
      end
    end ]] 
  end

  return {
    range = { node:range() },
    inner_range = inner_range
  }
end

M.find_closest_parent_react_node = function(n, node, buf)
  n = n or 1

  local count = 1
  local last_found = nil

  while node do
    local rinfo = M.is_react_node(node, buf)

    if rinfo then
      if count >= n then
        return rinfo
      end

      last_found = rinfo
      count = count + 1
    end

    node = node:parent()
  end

  return last_found
end

M.select_closest_parent = function(inner, n, node, winnr)
  winnr = winnr or vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winnr)
  node = node or ts_utils.get_node_at_cursor(winnr)
  
  local rinfo = M.find_closest_parent_react_node(n, node, buf)

  if rinfo then
    local r = (inner and rinfo.inner_range) or rinfo.range

    if r then ts_utils.update_selection(buf, r) end
  end
end

local range_contains = function(a, b, c, d, x, y, z, w)
  if a < x or c > z then
    return false
  elseif a > x and c < z then
    return true
  else
    if a == x and y < b then
      return false
    elseif c == z and w > d then
      return false
    else
      return true
    end
  end
end

M.search_for_node_at_pos = function(parent, root, t, a, b)
  if root ~= parent and vim.tbl_contains(t, root:type()) then
    -- print('type: ' .. root:type() .. ', a: ' .. tostring(a) .. ', b: ' .. tostring(b))
    if ts_utils.is_in_node_range(root, a-1, b) then
      for child in root:iter_children() do
        local node = M.search_for_node_at_pos(parent, child, t, a, b)

        if node then
          return node
        end
      end

      return root
    end
  end

  for child in root:iter_children() do
    local node = M.search_for_node_at_pos(parent, child, t, a, b)

    if node then
      return node
    end
  end
end

local to_comment_range = function(a, b, c, d)
  return {
    srow = a,
    scol = b,
    erow = c,
    ecol = d
  }
end

local toggle_comment = function ()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gb", true, false, true), '', false)
end

local toggle_comment_range = function(range, buf, winnr)
  local old_pos = vim.api.nvim_win_get_cursor(winnr or 0)

  ts_utils.update_selection(buf, range)
  toggle_comment()

  vim.schedule(function()
    vim.api.nvim_win_set_cursor(winnr, old_pos)
  end)
end

local untoggle_existing_comment = function(node, winnr)
  winnr = winnr or vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winnr)
  local parser = parsers.get_parser(buf)
  if not parser then return end

  local tree = parser:parse()[1]:root()
  local a, b = unpack(vim.api.nvim_win_get_cursor(winnr))
  local allowed_types = { 'description', 'comment', 'jsx_expression'}
  node = node or M.search_for_node_at_pos(tree, tree, allowed_types, a, b)
  
  if not node then
    return false
  end

  local t = node:type()

  if t == 'jsx_expression' then
    for child in node:iter_children() do
      if not vim.tbl_contains(allowed_types, child) then
        return false
      end
    end
  end

  local a, b, c, d = node:range()

  if t == 'description' or t == 'comment' or t == 'jsx_expression' then
    local curr = node
    while curr and curr:type() ~= 'jsx_expression' do
      curr = curr:parent()
    end

    if curr then
      -- ts_utils.update_selection(buf, curr)
      -- toggle_comment()

      toggle_comment_range(curr, buf, winnr)

      -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gb", true, false, true), '', false)
      
      return true
    end
  end

  return false
end

M.toggle_react_comment = function(n, winnr)
  winnr = winnr or vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winnr)
  local node = ts_utils.get_node_at_cursor(winnr)

  if not untoggle_existing_comment(nil, winnr) then
    local rinfo = M.find_closest_parent_react_node(n, node, buf)
    -- print(utils.dump(rinfo))
    if rinfo then
      -- ts_utils.update_selection(buf, rinfo.range)
      -- toggle_comment()
      toggle_comment_range(rinfo.range, buf, winnr)
    end
  end
end

return M
