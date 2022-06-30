local M = {}

local Log = require"user.log"

M.config = function()
  userconf.builtin.which_key = require"user.config.which-key-opts"
end

M.setup = function()
  local which_key_ok, which_key = pcall(require, "which-key")
  if not which_key_ok then
    Log:warn("Which key not found!")
    return
  end

  which_key.setup(userconf.builtin.which_key.setup)

  local opts = userconf.builtin.which_key.opts
  local vopts = userconf.builtin.which_key.vopts

  local mappings = userconf.builtin.which_key.mappings
  local vmappings = userconf.builtin.which_key.vmappings

  which_key.register(mappings, opts)
  which_key.register(vmappings, vopts)

  -- vim.keymap.del('n', "<leader>w")
  if userconf.builtin.which_key.on_config_done then
    userconf.builtin.which_key.on_config_done(which_key)
  end
end

M.register = function(mode, keymap, rhs, label)
  local lhs = userconf.builtin.which_key.leader_key .. keymap

  local keymaps = require("user.config.keymaps")

  local bindings = { [lhs] = rhs }

  keymaps.load({
    [mode] = bindings 
  })

  local wk_status_ok, wk = pcall(require, "which-key")
  if not wk_status_ok then
    return
  end

  wk.register({ [lhs] = { label }}, { mode = keymaps.get_mode(mode) or mode})
end

return M
