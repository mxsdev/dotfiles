return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_z = {
          function()
            -- return " " .. os.date("%r")

            return "  " .. os.date("%-I:%M %p")
          end,
        },
      },
    },
  },
}
