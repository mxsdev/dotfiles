local M = {}

function M.remap_keys(orig_keys, replace_map, set_false)
  local new_keys = {}

  for _, existing_key_config in ipairs(orig_keys) do
    local new_key_config = vim.deepcopy(existing_key_config)
    local key = existing_key_config[1]

    if replace_map[key] then
      if replace_map[key] ~= "" then
        new_key_config[1] = replace_map[key]
        table.insert(new_keys, new_key_config)
      end

      if set_false then
        table.insert(new_keys, { key, false })
      end
    else
      table.insert(new_keys, new_key_config)
    end
  end

  return new_keys
end

return M
