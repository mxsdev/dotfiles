return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      float_opts = {
        border = "curved",
      },
      persist_mode = false,
    },

    -- keys = {
    --   {
    --     "<C-/>",
    --     function()
    --       require("toggleterm").toggle(nil, nil, LazyVim.root(), "float")
    --     end,
    --     desc = "Toggle Floating Terminal",
    --   },
    -- },

    -- keys = function()
    --   return {
    --     {
    --       "<C-/>",
    --       function()
    --         require("toggleterm").toggle(nil, nil, LazyVim.root(), "float")
    --       end,
    --       { desc = "Toggle Floating Terminal" },
    --     },
    --   }
    -- end,
  },
}
