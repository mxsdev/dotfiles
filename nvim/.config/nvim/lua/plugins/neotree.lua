local remap_keys = require("util.remap").remap_keys

return {

  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = function(_, keys)
      return remap_keys(keys, {
        ["<leader>e"] = "",
        ["<leader>E"] = "",
        ["<leader>fe"] = "<leader>e",
        ["<leader>fE"] = "<leader>E",
      })
    end,
    opts = {
      filesystem = {
        window = {
          mappings = {
            ["d"] = "trash",
            -- ["D"] = "delete",
          },
        },
        commands = {
          trash = function(state)
            local inputs = require("neo-tree.ui.inputs")
            local path = state.tree:get_node().path
            local utils = require("neo-tree.utils")
            local _, name = utils.split_path(path)

            local msg = string.format("Are you sure you want to trash '%s'?", name)

            inputs.confirm(msg, function(confirmed)
              if not confirmed then
                return
              end

              pcall(function()
                vim.fn.system({ "trash", vim.fn.fnameescape(path) })
                if vim.v.shell_error ~= 0 then
                  msg = "trash command failed."
                  vim.notify(msg, vim.log.levels.ERROR, { title = "Neo-tree" })
                end
              end)

              require("neo-tree.sources.manager").refresh(state.name)
            end)
          end,

          trash_visual = function(state, selected_nodes)
            local inputs = require("neo-tree.ui.inputs")
            local msg = "Are you sure you want to trash " .. #selected_nodes .. " files ?"

            inputs.confirm(msg, function(confirmed)
              if not confirmed then
                return
              end

              for _, node in ipairs(selected_nodes) do
                pcall(function()
                  vim.fn.system({ "trash", vim.fn.fnameescape(node.path) })
                  if vim.v.shell_error ~= 0 then
                    msg = "trash command failed."
                    vim.notify(msg, vim.log.levels.ERROR, { title = "Neo-tree" })
                  end
                end)
              end

              require("neo-tree.sources.manager").refresh(state.name)
            end)
          end,
        },
      },

      event_handlers = {

        {
          event = "file_open_requested",
          handler = function()
            -- auto close
            -- vim.cmd("Neotree close")
            -- OR
            require("neo-tree.command").execute({ action = "close" })
          end,
        },

        {
          event = "file_added",
          handler = function(file_path)
            vim.cmd("e " .. file_path)

            -- require("neo-tree.command").execute({ action = "close" })

            -- vim.schedule(function()
            --   -- require("neo-tree.command").execute({ action = "close" })
            -- end)
          end,
        },
      },
    },
  },
}
