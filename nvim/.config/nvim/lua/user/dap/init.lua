local M = {}
local Log = require("user.log")
--[[ local js_dap = require"dap-vscode-js" ]]
local uutils = require"user.utils"

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

  --[[ return ]]

  -- local dap2 = require"user.dap.dap-js2"

  -- dap.adapters['pwa-node'] = dap2.connect

  --[[ js_dap.setup({ ]]
  --[[   log_file_level = vim.log.levels.TRACE, ]]
  --[[ }) ]]

  for _, language in ipairs({ "typescript", "javascript" }) do
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      -- {
      --   type = 'node',
      --   request = 'launch',
      --   name = 'Debug',
      --   program = '${file}',
      --   cwd = '${fileDirname}',
      --   -- sourceMaps = true,
      --   -- skipFiles = { '<node_internals>/**' },
      --   -- outputCapture = 'std',
      --   -- resolveSourceMapLocations = {
      --   --   '**',
      --   --   '!**/node_modules/**',
      --   -- },
      -- },
      -- {
      --   -- type = "node-terminal",
      --   type = "pwa-node",
      --   request = "launch",
      --   name = "Debug Jest Tests",
      --   -- program = "",
      --   trace = {
      --     console = false,
      --     level = "verbose",
      --     stdio = true,
      --   },
      --   runtimeExecutable = "node",
      --   runtimeArgs = {
      --     -- "--inspect-brk",
      --     "${workspaceFolder}/node_modules/jest/bin/jest.js",
      --     "--runInBand"
      --   },
      --   timeout = 10000,
      --   showAsyncStacks = true,
      --   skipFiles = {
      --     "<node_internals>/**"
      --   },
      --   smartStep = true,
      --   rootPath = "${workspaceFolder}",
      --   enableContentValidation = true,
      --   __workspaceFolder = "${workspaceFolder}",
      --   __breakOnConditionalError = true,
      --   cwd = "${workspaceFolder}",
      --   autoAttachChildProcesses = true,
      --   stopOnEntry = false,
      --   restart = false,
      --   profileStartup = false,
      --   outputCapture = "console",
      --   console = "integratedTerminal",
      --   internalConsoleOptions = "neverOpen",
      --   -- port = 9229,
      --   -- command = "yarn jest",
      -- }
      -- {
      --   type = "pwa-node",
      --   request = "launch",
      --   name = "Debug JS Tests",
      --   runtimeExecutable = "yarn",
      --   runtimeArgs = {
      --     -- "./node_modules/mocha/bin/mocha.js",
      --     "test"
      --   },
      --   rootPath = "${workspaceFolder}",
      --   cwd = "${workspaceFolder}",
      --   console = "integratedTerminal",
      --   internalConsoleOptions = "neverOpen",
      -- }
    }
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

  require"user.dap.neotest".setup()

  local is_ok, dap_js = pcall(require, "dap-vscode-js")

  if is_ok then
    dap_js.setup({
      -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
      -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
      -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
      -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
      -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
      -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    })
  end

  -- vim.g["test#strategy"] = "neovim"
  -- vim.g["test#javascript#runner"] = "jest"
  -- vim.g["test#javascript#jest#options"] = "--color=always"
  -- vim.g.ultest_use_pty = 1
  -- -- Don't show ultest output when on test
  -- vim.g.ultest_output_on_line = 0

  -- require("ultest").setup({
  --   builders = {
  --     ["typescript"] = function (cmd)
  --       print(uutils.dump(cmd))
  --
  --       return {
  --         dap = {
  --           name = "Debug Jest Tests",
  --           type = "pwa-node",
  --           request = "launch",
  --           runtimeArgs = cmd,
  --           console = "integratedTerminal",
  --           internalConsoleOptions = "neverOpen",
  --         },
  --       }
  --     end,
  --     -- ["typescriptreact"] = require("entropitor.dap.dap-js").ultest,
  --   },
  -- })
end

function M.test()
  local utils = require("user.utils")
  local workDir = vim.fn.getcwd()

  local launch_config = {
    args = {
      -- "--config=/Users/maxstoumen/Projects/test/jest.config.js",
      "--config=" .. utils.join_paths(workDir, "jest.config.js"),
      "--no-coverage",
      "--testLocationInResults",
      "--verbose",
      "--json",
      -- "--outputFile=/var/folders/d2/yrk2x5gd6dq4z2t3d7v3t0880000gn/T/nvim.maxstoumen/oIW7qq/0.json",
      "--testNamePattern='test 2$'",
      -- "/Users/maxstoumen/Projects/test/jest.test.ts",
      utils.join_paths(workDir, "integration.test.ts"),
    },
    console = "integratedTerminal",
    internalConsoleOptions = "neverOpen",
    name = "Debug Jest Tests",
    request = "launch",
    -- runtimeExecutable = "/Users/maxstoumen/Projects/test/node_modules/.bin/jest",
    runtimeExecutable = utils.join_paths(workDir, "node_modules/.bin/jest"),
    type = "pwa-node",
  }

  require("dap").run(launch_config)
end

return M
