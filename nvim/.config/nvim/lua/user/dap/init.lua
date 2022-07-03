local M = {}
local Log = require("user.log")

local dap_cfg = {
  custom = {
    adapters = { "python" },
    configurations = { "python" }
  }
}

function M.setup()
  local dap_installed, dap = pcall(require, "dap")
  if not dap_installed then
    Log:warn("DAP not installed!")
    return
  end

  for _, adapter_name in ipairs(dap_cfg.custom.adapters) do
    local adapter_installed, adapter_cfg = pcall(require, "user.dap.adapters." .. adapter_name)

    if not adapter_installed then
      Log:warn("Custom DAP adapter \"" .. adapter_name .. "\" not found!")
    else
      dap.adapters[adapter_name] = adapter_cfg
    end
  end

  for _, config_name in ipairs(dap_cfg.custom.configurations) do
    local config_installed, cust_cfg = pcall(require, "user.dap.configurations." .. config_name)

    if not config_installed then
      Log:warn("Custom DAP configuration \"" .. config_name .. "\" not found!")
    else
      dap.configurations[config_name] = cust_cfg
    end
  end

  -- - `DapBreakpoint` for breakpoints (default: `B`)
  -- - `DapBreakpointCondition` for conditional breakpoints (default: `C`)
  -- - `DapLogPoint` for log points (default: `L`)
  -- - `DapStopped` to indicate where the debugee is stopped (default: `→`)
  -- - `DapBreakpointRejected` to indicate breakpoints rejected by the debug
  --   adapter (default: `R`)

  -- vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})


  require"user.dap.ui".setup()
  require"user.dap.virtual-text".setup()

end

return M
