return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      for _, spec_entry in pairs(opts.spec[1]) do
        if spec_entry[1] == "<leader>w" then
          spec_entry[1] = "<leader>W"
        end
      end

      table.insert(opts.spec, {
        {
          "<leader>wm",
          hidden = true,
        },
      })

      return opts
    end,
  },
}
