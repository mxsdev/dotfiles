local M = {}
local uv = vim.loop
local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"

local init_path = debug.getinfo(1, "S").source:sub(2)
local base_dir = init_path:match("(.*[/\\])"):sub(1, -2)

--- Initialize lvim default configuration and variables
function M:init()
  userconf = vim.deepcopy(require "user.config.defaults")

  require("user.config.options").load_options()

  local builtins = require "user.core.builtins"
  builtins.config()

  local autocmds = require "user.core.autocmds"
  autocmds.load_defaults()
  
  require("user.config.keymaps").load_defaults()

  local lvim_lsp_config = require "user.lsp.config"
  userconf.lsp = vim.deepcopy(lvim_lsp_config)
end

-- Reload entire configuration file
function M:reload()
  for name,_ in pairs(package.loaded) do
    if name:match('^user') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end

---Join path segments that were passed as input
---@return string
function _G.join_paths(...)
  local result = table.concat({ ... }, path_sep)
  return result
end

---Require a module in protected mode without relying on its cached value
---@param module string
---@return any
function _G.require_clean(module)
  package.loaded[module] = nil
  _G[module] = nil
  local _, requested = pcall(require, module)
  return requested
end

---Get the full path to `$LUNARVIM_RUNTIME_DIR`
---@return string
function _G.get_runtime_dir()
  local lvim_runtime_dir = os.getenv "NVIM_RUNTIME_DIR"
  if not lvim_runtime_dir then
    -- when nvim is used directly
    return vim.call("stdpath", "data")
  end
  return lvim_runtime_dir
end

---Get the full path to `$LUNARVIM_CONFIG_DIR`
---@return string
function _G.get_config_dir()
  local lvim_config_dir = os.getenv "NVIM_CONFIG_DIR"
  if not lvim_config_dir then
    return vim.call("stdpath", "config")
  end
  return lvim_config_dir
end

---Get the full path to `$LUNARVIM_CACHE_DIR`
--
---@return string
function _G.get_cache_dir()
  local lvim_cache_dir = os.getenv "NVIM_CACHE_DIR"
  if not lvim_cache_dir then
    return vim.call("stdpath", "cache")
  end
  return lvim_cache_dir
end

function _G.get_base_dir()
  return base_dir
end

local utils = require"user.utils"
local user_config_dir = get_config_dir()
local user_config_file = utils.join_paths(user_config_dir, "config.lua")

---Get the full path to the user configuration file
---@return string
function M:get_user_config_path()
  return user_config_file
end

return M
