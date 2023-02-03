local M = {}

function M.setup()
  -- local neotest_jest = require("neotest-jest")({})

  -- local wrapped_build_spec = neotest_jest.build_spec
  --
  -- neotest_jest.build_spec = function(...)
  --   return vim.tbl_extend('error', wrapped_build_spec(...), {
  --     strategy = function (strategy, node, program, args)
  --       if strategy == 'dap' then
  --         return {
  --           type = "pwa-node",
  --           request = "launch",
  --           name = "Debug Jest Tests",
  --           trace = true,
  --           runtimeExecutable = "node",
  --           runtimeArgs = vim.list_extend({
  --             "./node_modules/jest/bin/jest.js",
  --             "--runInBand"
  --           }, args or {}),
  --           rootPath = "${workspaceFolder}",
  --           cwd = "${workspaceFolder}",
  --           console = "integratedTerminal",
  --           internalConsoleOptions = "neverOpen",
  --         }
  --       end
  --     end
  --   })
  -- end

  require('neotest').setup({
    adapters = {
      require("neotest-jest")({

      })
    }
  })
end

return M
