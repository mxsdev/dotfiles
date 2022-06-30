local M = {}
local headers = require("user.core.alpha.headers")

function M.get_sections()
  local header = {
    type = "text",
    val = headers.neovim,
    opts = {
      position = "center",
      hl = "Label",
    },
  }

  local text = require "user.interface.text"
  local ide_version = require("user.utils.git").get_version()

  local footer = {
    type = "text",
    val = text.align_center({ width = 0 }, {
      "",
      "mxs.dev",
      ide_version,
    }, 0.5),
    opts = {
      position = "center",
      hl = "Number",
    },
  }

  local buttons = {
    entries = {
      { "f", "  Find File", "<CMD>Telescope find_files<CR>" },
      { "n", "  New File", "<CMD>ene!<CR>" },
      { "p", "  Recent Projects ", "<CMD>Telescope projects<CR>" },
      { "r", "  Recently Used Files", "<CMD>Telescope oldfiles<CR>" },
      { "R", "  Most Recent File", "r<CR>"},
      { "t", "  Find Word", "<CMD>Telescope live_grep<CR>" },
      {
        "c",
        "  Configuration",
        "<CMD>edit " .. require("user.config"):get_user_config_path() .. " <CR>",
      },
    },
  }

  return {
    header = header,
    buttons = buttons,
    footer = footer,
  }
end

return M
