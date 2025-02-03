local remap_keys = require("util.remap").remap_keys

return {
  {
    "ibhagwan/fzf-lua",
    keys = function(_, orig_keys)
      table.insert(
        orig_keys,
        { "<leader>sd", "<cmd>FzfLua diagnostics_document sort=true<cr>", desc = "Document Diagnostics" }
      )

      table.insert(
        orig_keys,
        { "<leader>sD", "<cmd>FzfLua diagnostics_workspace sort=true<cr>", desc = "Workspace Diagnostics" }
      )

      return remap_keys(orig_keys, {
        ["<leader>ff"] = "<leader>f",
        ["<leader>fF"] = "<leader>sf",
        ["<leader>fg"] = "<leader>sfg",
        ["<leader>fr"] = "<leader>r",
        ["<leader>fR"] = "<leader>R",
        ["<leader>fb"] = "<leader>bf",
        ["<leader>fc"] = "<leader>sfc",
        ["<leader>fp"] = "<leader>sp",
      })
    end,
    opts = {
      -- TODO: find a way to fucking remove the stupid header

      -- fzf_opts = {
      --   ["--header"] = "",
      -- },
      files = {
        cwd_header = true,
      },
    },
  },
}
